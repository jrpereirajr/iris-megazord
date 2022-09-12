var id = document.getElementById("drawflow");
const editor = new Drawflow(id);
editor.reroute = true;
editor.start();

const welcome = {"drawflow":{"Home":{"data":{"1":{"id":1,"name":"welcome","data":{},"class":"welcome","html":"\n    <div>\n      <div class=\"title-box\">👏 Welcome to IRIS Flow!!</div>\n    <p>🎹 <b>Delete</b> for remove selected<br>\n        💠 Mouse Left Click == Move<br>\n        ❌ Mouse Right == Delete Option<br>\n        🔍 Ctrl + Wheel == Zoom<br>\n    </p>\n      </div>\n    </div>\n    ","typenode": false, "inputs":{},"outputs":{},"pos_x":50,"pos_y":50}}}}}
editor.import(welcome);


// Events!
editor.on('nodeCreated', function (id) {
    console.log("Node created " + id);
})

editor.on('nodeRemoved', function (id) {
    console.log("Node removed " + id);
})

editor.on('nodeSelected', function (id) {
    console.log("Node selected " + id);
})

editor.on('moduleCreated', function (name) {
    console.log("Module Created " + name);
})

editor.on('moduleChanged', function (name) {
    console.log("Module Changed " + name);
})

editor.on('connectionCreated', function (connection) {
    console.log('Connection created');
    console.log(connection);
})

editor.on('connectionRemoved', function (connection) {
    console.log('Connection removed');
    console.log(connection);
})

editor.on('nodeMoved', function (id) {
    console.log("Node moved " + id);
})

editor.on('zoom', function (zoom) {
    console.log('Zoom level ' + zoom);
})

editor.on('translate', function (position) {
    console.log('Translate x:' + position.x + ' y:' + position.y);
})

editor.on('addReroute', function (id) {
    console.log("Reroute added " + id);
})

editor.on('removeReroute', function (id) {
    console.log("Reroute removed " + id);
})

const fields2html = (fields) => {
    const json = JSON.parse(fields), form = [];;
    Object.getOwnPropertyNames(json).forEach(field => {
        hml = `<label class="col-form-label" for="${field}">${field}
                </label>
                <input type="text" class="form-control input-sm" id="${field}" placeholder="${field}" value="${json[field]}" oninput="this.setAttribute('value', this.value)">`
        form.push(hml);
    })
    return form.join('');
}

const addNodeToDrawFlow = (obj, pos_x, pos_y) => {

    if (editor.editor_mode === 'fixed') {
        return false;
    }
    pos_x = pos_x * (editor.precanvas.clientWidth / (editor.precanvas.clientWidth * editor.zoom)) - (editor.precanvas.getBoundingClientRect().x * (editor.precanvas.clientWidth / (editor.precanvas.clientWidth * editor.zoom)));
    pos_y = pos_y * (editor.precanvas.clientHeight / (editor.precanvas.clientHeight * editor.zoom)) - (editor.precanvas.getBoundingClientRect().y * (editor.precanvas.clientHeight / (editor.precanvas.clientHeight * editor.zoom)));
    const node = JSON.parse(obj);
    const nodeId = `${node.name + editor.nodeId}`;
    const nodeRamdonId = `${node.name}_${btoa(Math.random()*10000).slice(-6, -1)}`;
    const nodeNameTextbox = `<input type="text" id="${nodeId}" value="${nodeRamdonId}" oninput="this.setAttribute('value', this.value)"/>`;
    let content = '<div id="divHtmlNode_' + nodeId + '"><div class="title-box"><i class="' + node.icon + '" style="margin-right:5px"></i>' + nodeNameTextbox + '</div><div class="box">' + fields2html(node.Fields)  + '</div></div>';
    editor.addNode(node.name, node.input, node.output, pos_x, pos_y, node.name, {}, content);
}

var transform = '';
function showpopup(e) {
    e.target.closest(".drawflow-node").style.zIndex = "9999";
    e.target.children[0].style.display = "block";
    //document.getElementById("modalfix").style.display = "block";

    //e.target.children[0].style.transform = 'translate('+translate.x+'px, '+translate.y+'px)';
    transform = editor.precanvas.style.transform;
    editor.precanvas.style.transform = '';
    editor.precanvas.style.left = editor.canvas_x + 'px';
    editor.precanvas.style.top = editor.canvas_y + 'px';
    console.log(transform);

    //e.target.children[0].style.top  =  -editor.canvas_y - editor.container.offsetTop +'px';
    //e.target.children[0].style.left  =  -editor.canvas_x  - editor.container.offsetLeft +'px';
    editor.editor_mode = "fixed";

}

function closemodal(e) {
    e.target.closest(".drawflow-node").style.zIndex = "2";
    e.target.parentElement.parentElement.style.display = "none";
    //document.getElementById("modalfix").style.display = "none";
    editor.precanvas.style.transform = transform;
    editor.precanvas.style.left = '0px';
    editor.precanvas.style.top = '0px';
    editor.editor_mode = "edit";
}

function changeModule(event) {
    var all = document.querySelectorAll(".menu ul li");
    for (var i = 0; i < all.length; i++) {
        all[i].classList.remove('selected');
    }
    event.target.classList.add('selected');
}

function changeMode(option) {

    //console.log(lock.id);
    if (option == 'lock') {
        lock.style.display = 'none';
        unlock.style.display = 'block';
    } else {
        lock.style.display = 'block';
        unlock.style.display = 'none';
    }

}


const loadFlowMenu = (data) => {
    const flowmenu = document.querySelector('#flow-menu');
    if (!Array.isArray(data)) return;
    data.forEach(menu => {
        const nav = document.createElement("span"),
            icon = document.createElement("i"),
            li = document.createElement("li"),
            draggable = document.createElement("div"),
            textNode = document.createTextNode(menu.name);
        nav.appendChild(textNode);
        nav.classList.add('nav-text');
        menu.icon.split(' ').forEach(el => { icon.classList.add(el) })
        draggable.classList.add('drag-drawflow');
        draggable.setAttribute('ondragstart', 'drag(event)');
        draggable.setAttribute('draggable', true);
        draggable.setAttribute('data-node', JSON.stringify(menu));
        draggable.appendChild(icon);
        draggable.appendChild(nav);

        draggable.addEventListener('touchend', drop, false);
        draggable.addEventListener('touchmove', positionMobile, false);
        draggable.addEventListener('touchstart', drag, false);

        li.appendChild(draggable);
        flowmenu.appendChild(li);
    })
}

/* DRAG EVENT */

/* Mouse and Touch Actions */

var mobile_item_selec = '';
var mobile_last_move = null;
function positionMobile(ev) {
    mobile_last_move = ev;
}

function allowDrop(ev) {
    ev.preventDefault();
}

function drag(ev) {
    if (ev.type === "touchstart") {
        mobile_item_selec = ev.target.closest(".drag-drawflow").getAttribute('data-node');
    } else {
        ev.dataTransfer.setData("node", ev.target.getAttribute('data-node'));
    }
}

function drop(ev) {
    if (ev.type === "touchend") {
        var parentdrawflow = document.elementFromPoint(mobile_last_move.touches[0].clientX, mobile_last_move.touches[0].clientY).closest("#drawflow");
        if (parentdrawflow != null) {
            addNodeToDrawFlow(mobile_item_selec, mobile_last_move.touches[0].clientX, mobile_last_move.touches[0].clientY);
        }
        mobile_item_selec = '';
    } else {
        ev.preventDefault();
        console.table(ev.dataTransfer);
        let data = ev.dataTransfer.getData("node");
        addNodeToDrawFlow(data, ev.clientX, ev.clientY);
    }
}

const handleExport = () => {
    const prod_name = document.getElementById('production-name').value;
    if (!prod_name) {
        toastr.warning("Please enter the production name", "Warning", {
            positionClass: "toast-bottom-right",
            timeOut: 5e3,
            closeButton: !0,
            debug: !1,
            newestOnTop: !0,
            progressBar: !0,
            preventDuplicates: !0,
            onclick: null,
            showDuration: "300",
            hideDuration: "1000",
            extendedTimeOut: "1000",
            showEasing: "swing",
            hideEasing: "linear",
            showMethod: "fadeIn",
            hideMethod: "fadeOut",
            tapToDismiss: !1
        })

        return false;
    }
    const jsn = editor.export();
    if (!jsn.drawflow) return;
    if (!jsn.drawflow.Home) return;
    const flow = {};
    flow.nodes = [];
    flow.name = prod_name;
    production = jsn.drawflow.Home.data;
    Object.getOwnPropertyNames(production).forEach(el => {
        let element = production[el],
            thing = {};
        thing.type = "action";
        const nodeId = `${element.name}${element.id}`
        thing.name = document.getElementById(nodeId).value;
        element.html = document.getElementById(`divHtmlNode_${nodeId}`).outerHTML;
        if (!!element.html) {
            const config = {},
                parser = new DOMParser(),
                details = parser.parseFromString(element.html, "text/html");
            details.querySelectorAll('input.form-control.input-sm').forEach(node => {
                box_element = document.querySelector(`#node-${element.id} #${node.id}`);
                if (!!box_element) config[node.id] = box_element.value;
            })
            thing.config = config;
        }

        let sequence = [];
        for (output in element.outputs) {
            element.outputs[output].connections.forEach(conn => {
                let dest = production[conn.node];
                sequence.push({ "name": document.getElementById(`${dest.name}${dest.id}`).value });
            })
        }
        if (sequence.length > 0) {
            thing.targets = sequence;
        }
        flow.nodes.push(thing);
    });
    // todo: to be saved...
    diagram = {
        "name": document.getElementById('production-name').value,
        "def": jsn
    };
    console.log(JSON.stringify(diagram))

    diagram = {
        "name": prod_name,
        "def": editor.export()
    };
    postData('/csp/megazord/api/flow/save', diagram);

    console.log(flow);
    const data = postData('/csp/megazord/api/flow/generate', flow);
    console.table(data);
    if (!!data.errors) {
        let errors = data.errors.map(err => err.description || err.error);

        swal("Something went wrong!", errors.length > 0 ? errors.join(' ') : data.summary, "error");
    } else {
        toastr.success("", "Success!", {
            positionClass: "toast-bottom-right",
            timeOut: 5e3,
            closeButton: !0,
            debug: !1,
            newestOnTop: !0,
            progressBar: !0,
            preventDuplicates: !0,
            onclick: null,
            showDuration: "300",
            hideDuration: "1000",
            extendedTimeOut: "1000",
            showEasing: "swing",
            hideEasing: "linear",
            showMethod: "fadeIn",
            hideMethod: "fadeOut",
            tapToDismiss: !1
        })
    }
    console.log(data); // JSON data parsed by `data.json()` call
    return true;
}

const handleOpen = async () => {
    const prod_name = document.getElementById('production-name').value;
    if (!prod_name) {
        swal("Flow name not specified!", "", "error");
    };

    try {
        const data = await getData(`/csp/megazord/api/flow/get/${prod_name}`);
        if (!!data.drawflow) {
            editor.import(data);
            toastr.success("", "Success!", {
                positionClass: "toast-bottom-right",
                timeOut: 5e3,
                closeButton: !0,
                debug: !1,
                newestOnTop: !0,
                progressBar: !0,
                preventDuplicates: !0,
                onclick: null,
                showDuration: "300",
                hideDuration: "1000",
                extendedTimeOut: "1000",
                showEasing: "swing",
                hideEasing: "linear",
                showMethod: "fadeIn",
                hideMethod: "fadeOut",
                tapToDismiss: !1
            })
        }
    } catch(e) {
        if (!!e.errors) {
            let errors = e.errors.map(err => err.description || err.error);

            swal("Something went wrong!", errors.length > 0 ? errors.join(' ') : e.summary, "error");
        }
    }
}

async function postData(url = '', data = {}) {
    // Default options are marked with *
    const response = await fetch(url, {
        method: 'POST', // *GET, POST, PUT, DELETE, etc.
        mode: 'cors', // no-cors, *cors, same-origin
        cache: 'no-cache',
        credentials: 'same-origin',
        headers: {
            'Content-Type': 'application/json'
            // 'Content-Type': 'application/x-www-form-urlencoded',
        },
        redirect: 'follow', // manual, *follow, error
        referrerPolicy: 'no-referrer', // no-referrer, *no-referrer-when-downgrade, origin, origin-when-cross-origin, same-origin, strict-origin, strict-origin-when-cross-origin, unsafe-url
        body: JSON.stringify(data) // body data type must match "Content-Type" header
    });
    return response.json(); // parses JSON response into native JavaScript objects
}

async function getData(url = '') {
    // Default options are marked with *
    const response = await fetch(url, {
        method: 'GET', // *GET, POST, PUT, DELETE, etc.
        mode: 'cors', // no-cors, *cors, same-origin
        cache: 'no-cache',
        credentials: 'same-origin',
        headers: {
            'Content-Type': 'application/json'
            // 'Content-Type': 'application/x-www-form-urlencoded',
        },
        redirect: 'follow', // manual, *follow, error
        referrerPolicy: 'no-referrer' // no-referrer, *no-referrer-when-downgrade, origin, origin-when-cross-origin, same-origin, strict-origin, strict-origin-when-cross-origin, unsafe-url
    });
    if (response.ok) {
        return response.json(); // parses JSON response into native JavaScript objects
    } else {
        const error = await response.json()
        throw error;
    }
}

const searchComponents = () => {
    document.querySelectorAll('#flow-menu>li').forEach(item => {
        console.log(item.textContent);
        item.style.display = '';
    });
    let to_search = document.getElementById('flow-search-comp').value;
    if (to_search === '') return;

    document.querySelectorAll('#flow-menu>li').forEach(item => {
        if (item.textContent.toUpperCase().indexOf(to_search.toUpperCase()) > -1) {
            item.style.display = '';
        } else {
            item.style.display = 'none';
        }
    });
}

document.onreadystatechange = function (event) {
    if (document.readyState === "complete") {
        const getComponentOptions = () => {
            const response = fetch('/csp/megazord/api/components');
            response.then(res => res.json())
                .then(data => loadFlowMenu(data.data))
        }
        getComponentOptions();
    }
};
