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
                <input type="text" class="form-control input-sm" id="${field}" placeholder="${field}" value="${json[field]}">`
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
    console.log(obj);
    node = JSON.parse(obj);
    let content = '<div><div class="title-box"><i class="' + node.icon + '" style="margin-right:5px"></i>' + node.name + '</div><div class="box">' + fields2html(node.Fields)  + '</div></div>';
    console.log(content);
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

const loadDashboard = () => {
    console.log('change');
    const prod_name = document.getElementById('production-name').value;
    if (!prod_name) return;

    const dash = editor.export();
    if (!!dash.drawflow.Home) return;

    getData('/csp/irisflow/api/production/' + prod_name)
        .then(data => {
            console.log(data);
            if (!data.drawflow) {
                editor.import(data);
            }
        } )

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
        thing.name = element.name;
        if (!!element.html) {
            const config = {},
                parser = new DOMParser(),
                details = parser.parseFromString(element.html, "text/html");
            details.querySelectorAll('input').forEach(node => {
                box_element = document.querySelector(`#node-${element.id} #${node.id}`);
                if (!!box_element) config[node.id] = box_element.value;
            })
            thing.config = config;
        }

        let sequence = [];
        for (output in element.outputs) {
            element.outputs[output].connections.forEach(conn => {
                let dest = production[conn.node];
                sequence.push({ "name": dest.name });
            })
        }
        if (sequence.length > 0) {
            thing.targets = sequence;
        }
        flow.nodes.push(thing);
    });

    console.log(flow);
    postData('/csp/megazord/api/generate', flow)
        .then(data => {
            console.table(data);
            if (!!data.errors) {
                let errors = data.errors.map(err => err.description);

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
        });
    return true;
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
    return response.json(); // parses JSON response into native JavaScript objects
}



document.onreadystatechange = function (event) {
    if (document.readyState === "complete") {
        const getComponentOptions = () => {
            const response = fetch('/csp/megazord/api/components');
            response.then(res => res.json())
                .then(data => loadFlowMenu(data.data))
        }
        getComponentOptions();
        /*
        document.getElementById('production-name')
            .addEventListener("blur", loadDashboard());
        */
    }
};
