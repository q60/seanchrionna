import std.string: strip, wrap;
import std.conv: to;
import std.stdio: writefln;
import std.format: format;
import std.net.curl: get;
import dxml.dom;

void main() {
    string uri = "https://api.forismatic.com/api/1.0/?" ~
                 "method=getQuote&format=xml&lang=en";
    char[] response = get(uri);

    auto dom = parseDOM(response);
    auto quote = dom
        .children[0]  // <forismatic>
        .children[0]; // <quote>
    string quoteText = to!string(
        quote
            .children[0]
            .children[0]
            .text,
    );

    writefln(
        "\"\x1B[94m\x1B[1m%s\x1B[0m\"",
        strip(wrap(quoteText, 60, null, " ")),
    );

    if (quote.children[1].children.length != 0) {
        char[] quoteAuthor = quote
            .children[1]
            .children[0]
            .text;
        writefln("\x1B[93m%s\x1B[0m", strip(quoteAuthor));
    }
}
