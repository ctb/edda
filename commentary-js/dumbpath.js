/*************************************************************
 * dumbpath implementation
 *************************************************************/

var dumbpath = {};

dumbpath.findNode = function (doc, expr) {
    var tokens = dumbpath._dumbTokenize(expr);
    node = doc;
    for (var i=0; i<tokens.length; i++) {
        if (! tokens[i][0]) {
            continue;
        }
        node = tokens[i][0](node, tokens[i][1]);
    }
    return node;
}

dumbpath._dumbTokenize = function (expr) {
    var origExpr = expr;
    var tokens = [];
    while (expr) {
        var c0 = expr.charAt(0);
        if (c0 == ' ') {
            expr = expr.substr(1);
            continue;
        }
        var pos = origExpr.length - expr.length;
        if (c0 == '#') {
            /^#\(([^)]*)\)/.test(expr);
            expr = RegExp.rightContext;
            tokens.push([dumbpath._commentMatch, RegExp.$1]);
        } else if (c0 == '$') {
            /^[$]\(([^)]+)\)/.test(expr);
            expr = RegExp.rightContext;
            tokens.push([dumbpath._idMatch, RegExp.$1]);
        } else if (c0 == '<') {
            /^<(?:([\w-]+)|([\w-]*\.[\w-]*))(:-?\d+)?>/.test(expr);
            expr = RegExp.rightContext;
            tokens.push([dumbpath._tagMatch, 
                        [RegExp.$1, RegExp.$2, RegExp.$3]]);
        } else if (c0 == '+') {
            expr = expr.substr(1);
            tokens.push([dumbpath._positionMatch, 1]);
        } else if (c0 == '-') {
            expr = expr.substr(1);
            tokens.push([dumbpath._positionMatch, -1]);
        } else if (c0 == 'p' || c0 == 'P') {
            expr = expr.substr(1);
            tokens.push([dumbpath._parentMatch, null]);
        } else if (c0 == 'c' || c0 == 'C') {
            expr = expr.substr(1);
            tokens.push([dumbpath._childMatch, null]);
        } else {
            throw("unknown command: " + char0);
        }
    }
    return tokens;
}

dumbpath._commentMatch = function (node, comment) {
    return node;
}

dumbpath._idMatch = function (node, id) {
    return node.getElementById(id) || n;
}

dumbpath._tagMatch = function(node, tags) {
    var tagMatch = tags[0] || tags[1];
    var count = tags[2];
    if (count) {
        count = parseInt(count.substr(1));
    } else {
        count = 0;
    }
    if (tagMatch.indexOf('.') >= 0) {
        var tag = tagMatch.substr(0, tagMatch.indexOf('.'));
        var className = tagMatch.substr(tagMatch.indexOf('.')+1);
    } else {
        var tag = tagMatch;
        var className = '';
    }
    var elements = MochiKit.DOM.getElementsByTagAndClassName(
        tag, className, node);
    if (! elements.length) {
        return node;
    }
    if (count >= 0) {
        if (count >= elements.length) {
            return elements[elements.length-1];
        } else {
            return elements[count];
        }
    } else {
        if (-count > elements.length) {
            return elements[0];
        } else {
            return elements[elements.length+count];
        }
    }
}

dumbpath._positionMatch = function (node, dir) {
    var n = node;
    while (1) {
        if (dir > 0) {
            n = n.nextSibling;
        } else {
            n = n.previousSibling;
        }
        if (!n || n.nodeType == 1) {
            break;
        }
    }
    return n || node;
}

dumbpath._parentMatch = function (node) {
    return node.parentNode || node;
}

dumbpath._childMatch = function (node) {
    for (var i=0; i<node.childNodes.length; i++) {
        if (node.childNodes[i].nodeType == 1) {
            return node.childNodes[i];
        }
    }
    return node;
}

dumbpath.makeExpression = function (node) {
    var expr = '';
    var offset = '';
    while (1) {
        if (node.nodeType == 1 && node.tagName == 'BODY') {
            expr = ' <body> ' + offset + ' ' + expr;
            return expr;
        }
        if (node.getAttribute('id')) {
            expr = '$(' + node.getAttribute('id') + ') ' 
                   + offset + ' ' + expr;
            return expr;
        }
        var prev = node;
        while (1) {
            /* Go back on (non-text) element */
            prev = prev.previousSibling;
            if (! prev || prev.nodeType == 1) {
                break;
            }
        }
        if (! prev) {
            expr = 'c ' + offset + ' ' + expr;
            offset = '';
            node = node.parentNode;
        } else {
            node = prev;
            offset += '+';
        }
    }
}
