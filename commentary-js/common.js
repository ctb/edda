var D = MochiKit.DOM;

function submitCommentForm(form) {
    var container = form.containerDiv;
    var selElem = container.selectedElement;
    if (selElem) {
        unshowCommented(selElem);
    }
    var postBody = formQueryString(form);
    var action = form.getAttribute('action');
    action += '?_=t';
    d = doSimplePost(action, postBody);
    d.addCallbacks(function (data) {
        if (data.responseText == 'XXX') {
            unshowForm(container, selElem);
            return;
        }
        container.innerHTML = data.responseText;
    }, function (error) {
        container.innerHTML = error.req.responseText;
        D.addElementClass(container, 'commentary-error');
    });
    return false;
}

function submitFormInPlace(button) {
    var form = button.form;
    var postBody = formQueryString(form, ['inplace'], ['t']);
    var action = form.getAttribute('action');
    action += '?_=t';
    /* Start with a throb... */
    var effect = new Effect.Highlight(
        form.containerDiv,
        {startcolor: '#ffff88', endcolor: '#ff8888',
         restorecolor: '#ffff88', duration: 1000});
    d = doSimplePost(action, postBody);
    d.addCallbacks(function (data) {
        effect.cancel();
        /* Finish with green... */
        new Effect.Highlight(
            form.containerDiv,
        {startcolor: '#88ff88', endcolor: '#ffff88',
         restorecolor: '#ffff88'});
        if (form.elements.position_id) {
            var old = form.elements.position_id;
            old.setAttribute('name', 'comment_id');
            form.elements.comment_id = old;
            old.value = data.responseText;
            form.setAttribute('action', commentary_edit_uri);
        }
        return false;
    }, function (error) {
        var container = form.containerDiv;
        var errorContainer = D.DIV({'class': 'commentary-error'});
        errorContainer.innerHTML = error.req.responseText;
        container.appendChild(errorContainer);
    });
    return false;
}

function createCommentForm(position_id, inline) {
    var form, position, page, username, email;
    form = $('commentary-form').cloneNode(true);
    form.id = null;
    fixupForm(form);
    var formDiv = setupCommentForm(form, inline);
    position = form.elements.position_id;
    page = form.elements.page;
    position.value = position_id;
    page.value = commentary_this_page;
    return formDiv;
}

function setupCommentForm(form, inline) {
    var divClass = 'commentary-comment';
    if (inline) {
        divClass += ' commentary-inline';
    }
    var formDiv = D.DIV({'class': divClass, 'comment-meta': '1'});
    formDiv.appendChild(form);
    form.containerDiv = formDiv;
    formDiv.form = form;
    username = form.elements.username;
    email = form.elements.email;
    defaultLabel(username, 'Your name', 'username');
    defaultLabel(email, 'Your email', 'email');
    return formDiv;
}

function cancelSubmitForm(button) {
    var container = button.form.containerDiv;
    var selElem = container.selectedElement;
    if (selElem) {
        unshowCommented(container.selectedElement);
        D.removeElementClass(
            selElem, 'commentary-selected-element');
    }
    unshowForm(container, selElem);
    return false;
}

_elementsCommentedOn = [];

//cancelSubmitForm = MochiKit.Logging.catchException(cancelSubmitForm);

function commentOnElement(el) {
    for (var i=0; i<_elementsCommentedOn.length; i++) {
        if (el == _elementsCommentedOn[i]) {
            highlightCommented(el);
            return;
        }
    }
    var expr = dumbpath.makeExpression(el);
    var formDiv = createCommentForm(expr);
    formDiv.selectedElement = el;
    showCommented(el);
    D.addElementClass(formDiv, 'commentary-inline');
    showForm(formDiv, el);
    _elementsCommentedOn.push(el);
    try {
        formDiv.form.elements.comment.focus();
    } catch (e) {
        /* We can get an exception here because the visibility of the
           textarea hasn't registered yet. */
    }
}

function fixupForm(form) {
    tags = ['select', 'input', 'textarea', 'button'];
    for (var i=0; i<tags.length; i++) {
        var els = form.getElementsByTagName(tags[i]);
        for (var j=0; j<els.length; j++) {
            if (! form.elements[els[j].name]) {
                /* Only Mozilla really needs this... */
                form.elements[els[j].name] = els[j];
            }
        }
    }
}

function editLink(link, comment_id) {
    var container = findParent(link, 'commentary-comment');
    d = MochiKit.Async.doSimpleXMLHttpRequest(
        commentary_base + '/edit_comment',
        {_: 't', page: commentary_this_page,
         comment_id: comment_id, form: 't', z: Math.random()});
    d.addCallbacks(function(data) {
        var div = D.DIV();
        div.innerHTML = data.responseText;
        var form = div.getElementsByTagName('FORM')[0];
        fixupForm(form);
        var formDiv = setupCommentForm(form, true);
        appendSibling(formDiv, container);
        D.removeElement(container);
        form.elements.comment.focus();
    }, function (error) {
        container.innerHTML = error.req.responseText;
        D.addElementClass(container, 'commentary-error');
    });
    return false;
}

function deleteLink(link, comment_id) {
    if (! window.confirm('This will delete this comment permanently; are you sure?')) {
        return;
    }
    var container = findParent(link, 'commentary-comment');
    d = doSimplePost(commentary_base + '/delete_comment',
                     MochiKit.Base.queryString(
                     ['_', 'page', 'comment_id'],
                     ['t', commentary_this_page, comment_id]));
    d.addCallbacks(function (data) {
        unshowForm(container);
    }, function (error) {
        container.innerHTML = error.req.responseText;
        D.addElementClass(container, 'commentary-error');
    });
    return false;
}

/************************************************************
 * Effects
 ************************************************************/

function showCommented(el) {
    el.oldColor = el.style.backgroundColor;
    new Effect.Highlight(el, 
        {startcolor: '#ffffff', endcolor: '#ddddff',
         restorecolor: '#ddddff'});
}

function unshowCommented(el) {
    var endcolor = el.oldColor || '#ffffff';
    new Effect.Highlight(el,
        {duration: 0.5, startcolor: '#ddddff', endcolor: endcolor,
         restorecolor: endcolor});
}

function highlightCommented(el) {
    new Effect.Highlight(el,
        {duration: 0.4, startcolor: '#ff9999', endcolor: '#ddddff',
         restorecolor: '#ddddff'});
}    

function showForm(div, container) {
    div.style.display = 'none';
    if (container) {
        container.parentNode.insertBefore(div, container);
    }
    new Effect.Appear(div, 
        {duration: 0.3, afterFinish: function () {
            div.form.elements.comment.focus();}});
}

function unshowForm(div, selectedElement) {
    if (selectedElement) {
        for (var i=0; i<_elementsCommentedOn.length; i++) {
            if (_elementsCommentedOn[i] == selectedElement) {
                _elementsCommentedOn[i] = null;
            }
        }
    }
    new Effect.DropOut(div, 
        {duration: 0.4, afterFinish: function () {
            D.removeElement(div);}});
}
        

/************************************************************
 * Setup
 ************************************************************/

document.ondblclick = function (event) {
    if (event) {
        var el = event.target;
    } else {
        event = window.event;
        var el = event.srcElement;
    }
    el = findBlockContainer(el);
    var parent = el;
    while (parent) {
        if (parent.getAttribute 
            && parent.getAttribute('comment-meta')) {
            /* This is something that belongs to the comment system,
               and cannot itself be commented on. */
            return;
        }
        parent = parent.parentNode;
    }
    if (el) {
        commentOnElement(el);
    }
}

/* We only want this class to be hidden when in a Javascript-enabled
   browser:
*/
document.write('<style type="text/css">\n'
               + '.hidden {display: none}\n'
               + '</style>\n');

/*window.onerror = function (desc, page, line, chr) {
    alert(desc+': '+page+'\nline: '+line+', '+chr);
    alert(window.event);
}*/

/************************************************************
 * Generic form handling
 ************************************************************/

function formValues(form) {
    /* Returns an array of [keys, values] from the form.
       Also handles the attributes that defaultLabel puts on
       elements (labelValue and cookieName). */
    var keys = [];
    var values = [];
    for (var i=0; i < form.elements.length; i++) {
        var el = form.elements[i];
        var elType = (el.getAttribute('type') || '').toLowerCase();
        if (elType == 'submit') {
            continue;
        }
        if ((elType == 'radio' || elType == 'checkbox')
            && ! el.checked) {
            continue;
        }
        var value = el.value;
        if (el.labelValue && el.labelValue == el.value) {
            value = '';
        }
        if (el.cookieName && value) {
            createCookie(el.cookieName, value, 180);
        }
        keys.push(el.name);
        values.push(value);
    }
    return [keys, values]
}

function formQueryString(form, /*optional:*/ extraKeys, extraValues) {
    /* Creates a query string from inputs in the given form.  If
       extraKeys and extraValues is given, those values will also
       be included. */
    var fields = formValues(form);
    var keys = fields[0];
    var values = fields[1];
    if (extraKeys) {
        for (var i=0; i<extraKeys.length; i++) {
            keys.push(extraKeys[i]);
            values.push(extraValues[i]);
        }
    }
    return MochiKit.Base.queryString(keys, values);
}

function doSimplePost(action, postBody) {
    /* Do a POST request to the given action, with the URL-encoded
       postBody (typically created with formQueryString).  Returns
       a Deferred. */
    var req = MochiKit.Async.getXMLHttpRequest();
    req.open('POST', action, true);
    req.setRequestHeader(
        'Content-type', 'application/x-www-form-urlencoded');
    return MochiKit.Async.sendXMLHttpRequest(req, postBody);
}

function findParent(node, cond, /* optional */ defaultValue) {
    if (typeof(cond) == 'string') {
        var nodeClass = cond;
        cond = function (node) {
            return D.hasElementClass(node, nodeClass);
        };
    }
    while (node) {
        if (cond(node)) {
            return node;
        }
        node = node.parentNode;
    }
    return defaultValue;
}

/************************************************************
 * Utility functions
 ************************************************************/

function defaultLabel(el, label, cookieName) {
    /* Setup a input element with the given label (as its value)
       or the value loaded from the given cookie. */
    var cookieValue;
    if (cookieName) {
        el.cookieName = cookieName;
        if (cookieValue = readCookie(cookieName)) {
            el.value = cookieValue;
            return;
        }
    }
    var parent = el.parentNode;
    while (parent) {
        if (parent.tagName == 'FORM') {
            break;
        }
        parent = parent.parentNode;
    }
    el.value = label;
    el.labelValue = label;
    el.onfocus = _focusDefaultLabel;
    D.addElementClass(el, 'commentary-unselected');
}

function _focusDefaultLabel() {
    var el = this;
    D.removeElementClass(el, 'commentary-unselected');
    if (el.value == el.labelValue) {
        el.value = '';
    }
}

function appendSibling(node, sibling) {
    var next = sibling.nextSibling;
    if (next) {
        sibling.parentNode.insertBefore(node, next);
    } else {
        sibling.parentNode.appendChild(node);
    }
}

_blocks = {DIV: true, P: true, 
           PRE: true, CENTER: true, BLOCKQUOTE: true, 
           H1: true, H2: true, H3: true, 
           H4: true, H5: true, H6: true, 
           TD: true, TH: true, 
           FORM: true, FIELDSET: true, 
           DD: true, DL: true, TABLE: true,
           OL: true, UL: true, LI: true};

function findBlockContainer(el) {
    var node = el;
    while (node) {
        if (_blocks[node.tagName]) {
            return node;
        }
        node = node.parentNode;
    }
    throw('No block-level element found for ' + el);
}

function makeId() {
    return 'commentary-' + (commentary_id++);
}

function cancelEvent(event) {
    event.returnValue = false;
    event.cancelBubble = true;
    event.preventDefault && event.preventDefault();
    event.stopPropagation && event.stopPropagation();
    return false;
}

/************************************************************
 * Cookies
 ************************************************************/

/* From: http://www.quirksmode.org/js/cookies.html */

function createCookie(name,value,days)
{
    if (days)
        {
            var date = new Date();
            date.setTime(date.getTime()+(days*24*60*60*1000));
            var expires = "; expires="+date.toGMTString();
        }
    else var expires = "";
    document.cookie = name+"="+value+expires+"; path=/";
}

function readCookie(name)
{
    var nameEQ = name + "=";
    var ca = document.cookie.split(';');
    for(var i=0;i < ca.length;i++)
        {
            var c = ca[i];
            while (c.charAt(0)==' ') c = c.substring(1,c.length);
            if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
        }
    return null;
}

function eraseCookie(name)
{
    createCookie(name,"",-1);
}
