interface ProxyOptions {
    auth?: string;
    host: string;
    port?: number;
    protocol?: string;
}

interface InitRequestOptions {
    auth?: string;
    cookies?: { [key: string]: string };
    cookies_jar?: string;
    family?: 4 | 6;
    headers?: { [key: string]: string | string[] };
    proxy?: string | ProxyOptions;
    timeout?: number;
}

interface RequestOptionsPure {
    auth?: string;
    cookies?: { [key: string]: string };
    family?: 4 | 6;
    headers?: { [key: string]: string | string[] };
    proxy?: string | ProxyOptions;
    timeout?: number;
}

interface RequestOptionsWithData extends RequestOptionsPure {
    data?: string | { [key: string]: string };
}

interface RequestOptionsWithForm extends RequestOptionsPure {
    form_data?: { [key: string]: string };
}

interface RequestOptionsWithJson extends RequestOptionsPure {
    json_data?: { [key: string]: string };
}

interface Response {
    data: string | object;
    headers: { [key: string]: string[] };
    raw_data: string;
    status_code: number;
    status_text: string;
}

type RequestCallback = (error: Error | null, response: Response) => void;

type RequestOptions = RequestOptionsPure | RequestOptionsWithData | RequestOptionsWithForm | RequestOptionsWithJson;

interface Request {
    abort(): void;
}

declare class HttpClient {
    static available: boolean;

    constructor(options?: InitRequestOptions);

    delete(url: string, callback?: RequestCallback): Request;

    delete(url: string, options?: RequestOptions, callback?: RequestCallback): Request;

    get(url: string, callback?: RequestCallback): Request;

    get(url: string, options?: RequestOptions, callback?: RequestCallback): Request;

    head(url: string, callback?: RequestCallback): Request;

    head(url: string, options?: RequestOptions, callback?: RequestCallback): Request;

    post(url: string, callback?: RequestCallback): Request;

    post(url: string, options?: RequestOptions, callback?: RequestCallback): Request;

    put(url: string, callback?: RequestCallback): Request;

    put(url: string, options?: RequestOptions, callback?: RequestCallback): Request;

    request(method: string, url: string, callback?: RequestCallback): Request;

    request(method: string, url: string, options?: RequestOptions, callback?: RequestCallback): Request;
}

export = HttpClient;
