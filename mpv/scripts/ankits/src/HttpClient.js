/**
 * All JSDoc declarations in this file are just to make the development process
 * easier, you should always look at the type declarations in HttpClient.d.ts.
 */

'use strict';

var msg = mp.msg;
var utils = mp.utils;

/**
 * @param {IArguments} args
 * @returns {Array}
 */
var arguments2array = function arguments2array(args) {
    return [].slice.call(args).filter(function(v) { return v !== undefined; });
};

var maybe_function = function maybe_function(fn) {
    return typeof fn === 'function' ? fn : function() {};
};

var maybe_number = function maybe_number(num) {
    return typeof num === 'number' ? num : 0;
};

var maybe_object = function maybe_object(obj) {
    return typeof obj === 'object' ? obj : Object.create(null);
};

var maybe_string = function maybe_string(str) {
    return typeof str === 'string' ? str : '';
};

/**
 * @typedef {Object} SubprocessResult
 * @property {number} status
 * @property {string} stdout
 * @property {string} stderr
 * @property {string} error_string
 * @property {boolean} killed_by_us
 */

/**
 * @param {...string} args
 * @returns {SubprocessResult}
 */
var subprocess = function subprocess() {
    return mp.command_native({
        name: 'subprocess',
        args: arguments2array(arguments),
        playback_only: false,
        capture_stdout: true,
        capture_stderr: true,
    });
};

/**
 * @returns {string|undefined}
 */
var detect_os = function detect_os() {
    var home = utils.getenv('USERPROFILE');
    if (typeof home === 'string' && /^[A-Z]:|^\\\\/i.test(home)) {
        return 'windows';
    }
    var process = subprocess('uname', '-s');
    if (process.status === 0) {
        var os = process.stdout.trim();
        if (os === 'Linux') {
            return 'linux';
        }
        if (os === 'Darwin') {
            return 'macos';
        }
    }
    return undefined;
};

var OS = detect_os();

/**
 * @returns {string|undefined}
 */
var detect_curl = function detect_curl() {
    var process;
    var result = '';
    if (OS === 'windows') {
        process = subprocess('where.exe', 'curl.exe');
        if (process.status === 0) {
            result = process.stdout.split('\n')[0].trim();
        }
    } else {
        process = subprocess('sh', '-c', 'command -p -v curl');
        if (process.status === 0) {
            result = process.stdout.trim();
        }
    }
    return result === '' ? undefined : result;
};

var CURL = detect_curl();

/**
 * @param {string[]} opts
 * @param {function} cb
 * @returns {{abort: function}}
 */
var curl_exec = function curl_exec(opts, cb) {
    var command_opts = [
        '--anyauth', // Auto-detect auth method
        '--disable', // Disable curlrc config file
        '--include', // Include headers in output
        '--location', // Follow redirect
        '--no-progress-meter', // Disable progress bar display
        '--proto', '=http,https', // Allowed protocols
        '--proxy-anyauth', // Auto-detect auth method for proxy
    ];
    var args = [CURL].concat(command_opts, opts);
    msg.verbose(args.join(' '));
    var process = mp.command_native_async({
        name: 'subprocess',
        args: args,
        playback_only: false,
        capture_stdout: true,
        capture_stderr: true,
    }, cb);
    return {
        abort: mp.abort_async_command.bind(this, process),
    };
};

/**
 * @typedef {Object} ProxyOptions
 * @property {string} [auth]
 * @property {string} host
 * @property {number} [port]
 * @property {string} [protocol]
 */

/**
 * @typedef {Object} InitRequestOptions
 * @property {string} [auth]
 * @property {Object.<string, string>} [cookies]
 * @property {string=} [cookies_jar]
 * @property {number} [family]
 * @property {Object.<string, string, string[]>} [headers]
 * @property {string|ProxyOptions} [proxy]
 * @property {number} [timeout]
 */

/**
 * @typedef {Object} RequestOptions
 * @property {string} [auth]
 * @property {Object.<string, string>} [cookies]
 * @property {string|Object<string, string>} [data]
 * @property {number} [family]
 * @property {Object.<string, string>} [form_data]
 * @property {Object.<string, string, string[]>} [headers]
 * @property {Object.<string, string>} [json_data]
 * @property {string|ProxyOptions} [proxy]
 * @property {number} [timeout]
 */

/**
 * @param {InitRequestOptions|RequestOptions} options
 * @returns {string[]}
 */
var options_to_curl_opts = function options_to_curl_opts(options) {
    var opts = [];
    if (typeof options.auth === 'string') {
        opts.push('--user', options.auth);
    }
    if (typeof options.cookies === 'object') {
        Object.keys(options.cookies).forEach(function(k) {
            opts.push('--cookie', k.concat('=', options.cookies[k]));
        });
    }
    if (typeof options.cookies_jar === 'string') {
        opts.push('--cookie-jar', options.cookies_jar);
    }
    if (typeof options.data === 'string') {
        opts.push('--data-raw', options.data);
    }
    if (typeof options.data === 'object') {
        Object.keys(options.data).forEach(function(k) {
            opts.push('--data-urlencode', k.concat('=', options.data[k]));
        });
    }
    if (typeof options.form_data === 'object') {
        Object.keys(options.form_data).forEach(function(k) {
            opts.push('--form', k.concat('=', options.form_data[k]));
        });
    }
    if (typeof options.family === 'number') {
        opts.push(options.family === 6 ? '--ipv6' : '--ipv4');
    }
    if (typeof options.headers === 'object') {
        Object.keys(options.headers).forEach(function(k) {
            var arr = options.headers[k];
            if (typeof arr === 'string') {
                arr = [arr];
            }
            arr.forEach(function(v) {
                opts.push('--header', k.concat(': ', v));
            });
        });
    }
    if (typeof options.json_data === 'object') {
        opts.push('--json', JSON.stringify(options.json_data));
    }
    if (typeof options.proxy === 'string') {
        opts.push('--proxy', options.proxy);
    }
    if (typeof options.proxy === 'object') {
        var proxy = options.proxy;
        var p_protocol = maybe_string(proxy.protocol) || 'http';
        var p_host = maybe_string(proxy.host);
        var p_port = maybe_number(proxy.port);
        if (p_host !== '') {
            opts.push('--proxy',
                p_protocol + '://' + p_host + (p_port ? ':' + p_port : ''));
        }
        if (typeof proxy.auth === 'string') {
            opts.push('--proxy-user', proxy.auth);
        }
    }
    if (typeof options.timeout === 'number') {
        opts.push('--connect-timeout', options.timeout.toString());
    }
    return opts;
};

/**
 * @typedef {Object} HeaderResult
 * @property {Object.<string, string[]>} headers
 * @property {number} status_code
 * @property {string} status_text
 */

/**
 * @param {string} head
 * @returns {HeaderResult|undefined}
 */
var parse_http_head = function parse_http_head(head) {
    if (head.substring(0, 4).toUpperCase() !== 'HTTP') {
        return undefined;
    }
    var lines = head.split('\n').map(function(v) { return v.replace('\r', ''); });
    var firstLine = lines.shift();
    var status = firstLine.substring(firstLine.indexOf(' ') + 1);
    var status_code = parseInt(status.substring(0, 3)) || 0;
    var status_text = status.substring(4);
    var headers = Object.create(null);
    lines.forEach(function(line) {
        var pos = line.indexOf(':');
        if (pos === -1) {
            return;
        }
        var name = line.substring(0, pos).toLowerCase();
        var value = line.substring(pos + 1).replace(/^\s+/, '');
        if (!Object.prototype.hasOwnProperty.call(headers, name)) {
            headers[name] = [];
        }
        headers[name].push(value);
    });
    return {
        headers: headers,
        status_code: status_code,
        status_text: status_text,
    };
};

/**
 * @typedef {Object} Response
 * @property {string|Object} data
 * @property {Object.<string, string[]>} headers
 * @property {string} raw_data
 * @property {number} status_code
 * @property {string} status_text
 */

/**
 * @param {string} output
 * @returns {Response}
 */
var parse_curl_output = function parse_curl_output(output) {
    var curl_output = output;
    var body = '';
    var headers = Object.create(null);
    var status_code = 0;
    var status_text = '';

    while (true) {
        var header_end_pos = curl_output.indexOf('\r\n\r\n');
        if (header_end_pos === -1) {
            break;
        }
        var header_text = curl_output.substring(0, header_end_pos);
        var http_meta = parse_http_head(header_text);
        if (http_meta === undefined) {
            break;
        } else {
            body = curl_output.substring(header_end_pos + 4);
            headers = http_meta.headers;
            status_code = http_meta.status_code;
            status_text = http_meta.status_text;
        }
        if (status_code < 300 || status_code >= 400) {
            break;
        }
        curl_output = curl_output.substring(header_end_pos + 4);
    }

    var result = {
        data: body,
        headers: headers,
        raw_data: body,
        status_code: status_code,
        status_text: status_text,
    };

    if (Object.prototype.hasOwnProperty.call(headers, 'content-type')) {
        var contentType = headers['content-type'];
        for (var i = 0; i < contentType.length; i++) {
            var type = contentType[i];
            if (type.indexOf('application/json') === 0) {
                try {
                    result.data = JSON.parse(result.raw_data);
                } catch (err) {
                }
                break;
            }
        }
    }

    return result;
};

/**
 * @callback RequestCallback
 * @param {null|Error} error
 * @param {Response} response
 */

var HttpClient = function HttpRequest() {
    function HttpClient(options) {
        this.init_options = maybe_object(options);
    }

    var _proto = HttpClient.prototype;
    /**
     * @param {string} method
     * @param {string} url
     * @param {RequestCallback|RequestOptions} options
     * @param {RequestCallback} callback
     */
    _proto.request = function request(method, url, options, callback) {
        /** @type {RequestOptions} */
        var obj = maybe_object(options);
        /** @type {RequestCallback} */
        var cb = maybe_function(callback || options);

        var not_allow_data = ['GET', 'HEAD'].indexOf(method.toUpperCase()) !== -1;

        var o = {};
        Object.keys(this.init_options).forEach((function(k) {
            o[k] = this.init_options[k];
        }).bind(this));
        Object.keys(obj).forEach((function(k) {
            // GET request does not allow data
            if (not_allow_data && ['data', 'form_data', 'json_data'].indexOf(k) !== -1) {
                return;
            }
            o[k] = obj[k];
        }).bind(this));

        var opts = options_to_curl_opts(o);
        opts.push('--request', method);
        opts.push('--url', url);

        /**
         * @param {boolean} success
         * @param {SubprocessResult=} result
         * @param {string=} error
         */
        var curl_cb = function curl_cb(success, result, error) {
            if (success === false || result.status !== 0) {
                var message = result === undefined ? error : (result.stderr || result.error_string);
                cb(new Error(message), undefined);
                return;
            }
            cb(null, parse_curl_output(result.stdout));
        };

        return curl_exec(opts, curl_cb);
    };

    _proto.delete = function() {
        return this.request.apply(this, ['DELETE'].concat(arguments2array(arguments)));
    };
    _proto.get = function() {
        return this.request.apply(this, ['GET'].concat(arguments2array(arguments)));
    };
    _proto.head = function() {
        return this.request.apply(this, ['HEAD'].concat(arguments2array(arguments)));
    };
    _proto.post = function() {
        return this.request.apply(this, ['POST'].concat(arguments2array(arguments)));
    };
    _proto.put = function() {
        return this.request.apply(this, ['PUT'].concat(arguments2array(arguments)));
    };
    return HttpClient;
}();

HttpClient.available = CURL !== undefined;

export default HttpClient;
