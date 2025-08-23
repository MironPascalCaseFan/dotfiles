const c = 0.551915024494; // circle approximation

export default class AssDraw {
    scale: number;
    text: string;

    constructor() {
        this.scale = 4;
        this.text = "";
    }

    new_event(): this {
        if (this.text.length > 0) this.text += "\n";
        return this;
    }

    setsize(size: number): this {
      this.append(`{\\fs${size}}`);
      return this;
    }

    newline(): this {
      this.text += "\\N"
      return this;
    }

    bold(text: string): this {
      this.append(`{\\b1}${text}{\\b0}`);
      return this;
    }

    tab(): this {
      this.append('\\h\\h\\h\\h');
      return this;
    }

    draw_start(): this {
        this.text += `{\\p${this.scale}}`;
        return this;
    }

    draw_stop(): this {
        this.text += "{\\p0}";
        return this;
    }

    coord(x: number, y: number): this {
        const scale = Math.pow(2, this.scale - 1);
        const ix = Math.ceil(x * scale);
        const iy = Math.ceil(y * scale);
        this.text += ` ${ix} ${iy}`;
        return this;
    }

    append(s: string): this {
        this.text += s;
        return this;
    }

    merge(other: AssDraw): this {
        this.text += other.text;
        return this;
    }

    pos(x: number, y: number): this {
        return this.append(`{\\pos(${x},${y})}`);
    }

    an(an: number): this {
        return this.append(`{\\an${an}}`);
    }

    move_to(x: number, y: number): this {
        this.append(" m");
        return this.coord(x, y);
    }

    line_to(x: number, y: number): this {
        this.append(" l");
        return this.coord(x, y);
    }

    bezier_curve(x1: number, y1: number, x2: number, y2: number, x3: number, y3: number): this {
        this.append(" b");
        this.coord(x1, y1);
        this.coord(x2, y2);
        return this.coord(x3, y3);
    }

    rect_ccw(x0: number, y0: number, x1: number, y1: number): this {
        return this.move_to(x0, y0)
            .line_to(x0, y1)
            .line_to(x1, y1)
            .line_to(x1, y0);
    }

    rect_cw(x0: number, y0: number, x1: number, y1: number): this {
        return this.move_to(x0, y0)
            .line_to(x1, y0)
            .line_to(x1, y1)
            .line_to(x0, y1);
    }

    hexagon_cw(x0: number, y0: number, x1: number, y1: number, r1: number, r2: number = r1): this {
        this.move_to(x0 + r1, y0);
        if (x0 !== x1) this.line_to(x1 - r2, y0);
        this.line_to(x1, y0 + r2);
        if (x0 !== x1) this.line_to(x1 - r2, y1);
        this.line_to(x0 + r1, y1);
        return this.line_to(x0, y0 + r1);
    }

    hexagon_ccw(x0: number, y0: number, x1: number, y1: number, r1: number, r2: number = r1): this {
        this.move_to(x0 + r1, y0)
            .line_to(x0, y0 + r1)
            .line_to(x0 + r1, y1);
        if (x0 !== x1) this.line_to(x1 - r2, y1);
        this.line_to(x1, y0 + r2);
        if (x0 !== x1) this.line_to(x1 - r2, y0);
        return this;
    }

    round_rect_cw(x0: number, y0: number, x1: number, y1: number, r1: number, r2: number = r1): this {
        const c1 = c * r1;
        const c2 = c * r2;

        this.move_to(x0 + r1, y0)
            .line_to(x1 - r2, y0);

        if (r2 > 0) this.bezier_curve(x1 - r2 + c2, y0, x1, y0 + r2 - c2, x1, y0 + r2);
        this.line_to(x1, y1 - r2);
        if (r2 > 0) this.bezier_curve(x1, y1 - r2 + c2, x1 - r2 + c2, y1, x1 - r2, y1);

        this.line_to(x0 + r1, y1);
        if (r1 > 0) this.bezier_curve(x0 + r1 - c1, y1, x0, y1 - r1 + c1, x0, y1 - r1);

        this.line_to(x0, y0 + r1);
        if (r1 > 0) this.bezier_curve(x0, y0 + r1 - c1, x0 + r1 - c1, y0, x0 + r1, y0);

        return this;
    }

    round_rect_ccw(x0: number, y0: number, x1: number, y1: number, r1: number, r2: number = r1): this {
        const c1 = c * r1;
        const c2 = c * r2;

        this.move_to(x0 + r1, y0);
        if (r1 > 0) this.bezier_curve(x0 + r1 - c1, y0, x0, y0 + r1 - c1, x0, y0 + r1);

        this.line_to(x0, y1 - r1);
        if (r1 > 0) this.bezier_curve(x0, y1 - r1 + c1, x0 + r1 - c1, y1, x0 + r1, y1);

        this.line_to(x1 - r2, y1);
        if (r2 > 0) this.bezier_curve(x1 - r2 + c2, y1, x1, y1 - r2 + c2, x1, y1 - r2);

        this.line_to(x1, y0 + r2);
        if (r2 > 0) this.bezier_curve(x1, y0 + r2 - c2, x1 - r2 + c2, y0, x1 - r2, y0);

        return this;
    }
}
