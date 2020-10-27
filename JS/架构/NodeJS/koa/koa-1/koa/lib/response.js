let response = {
    _body: undefined,
    set body(value) {
        this._body = value;
    },
    get body() {
        return this._body
    }
}
module.exports = response;

// defineProperty