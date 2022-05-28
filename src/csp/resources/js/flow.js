var id = document.getElementById("drawflow");
    const editor = new Drawflow(id);
    editor.reroute = true;
    editor.start();

    /*
    editor.addNode('welcome', 0, 0, 50, 50, 'welcome', {}, welcome );
    */

    // Events!
    editor.on('nodeCreated', function(id) {
      console.log("Node created " + id);
    })

    editor.on('nodeRemoved', function(id) {
      console.log("Node removed " + id);
    })

    editor.on('nodeSelected', function(id) {
      console.log("Node selected " + id);
    })

    editor.on('moduleCreated', function(name) {
      console.log("Module Created " + name);
    })

    editor.on('moduleChanged', function(name) {
      console.log("Module Changed " + name);
    })

    editor.on('connectionCreated', function(connection) {
      console.log('Connection created');
      console.log(connection);
    })

    editor.on('connectionRemoved', function(connection) {
      console.log('Connection removed');
      console.log(connection);
    })

    editor.on('nodeMoved', function(id) {
      console.log("Node moved " + id);
    })

    editor.on('zoom', function(zoom) {
      console.log('Zoom level ' + zoom);
    })

    editor.on('translate', function(position) {
      console.log('Translate x:' + position.x + ' y:'+ position.y);
    })

    editor.on('addReroute', function(id) {
      console.log("Reroute added " + id);
    })

    editor.on('removeReroute', function(id) {
      console.log("Reroute removed " + id);
    })




   const addNodeToDrawFlow = (obj, pos_x, pos_y) => {

      if(editor.editor_mode === 'fixed') {
        return false;
      }
      pos_x = pos_x * ( editor.precanvas.clientWidth / (editor.precanvas.clientWidth * editor.zoom)) - (editor.precanvas.getBoundingClientRect().x * ( editor.precanvas.clientWidth / (editor.precanvas.clientWidth * editor.zoom)));
      pos_y = pos_y * ( editor.precanvas.clientHeight / (editor.precanvas.clientHeight * editor.zoom)) - (editor.precanvas.getBoundingClientRect().y * ( editor.precanvas.clientHeight / (editor.precanvas.clientHeight * editor.zoom)));
      console.log(obj);
      node = JSON.parse(obj);
	  let content = '<div><div class="title-box"><i class="' + node.icon + '" style="margin-right:5px"></i>' + node.name +'</div><div class="box"><textarea>'+ node.Fields + '</textarea></div></div>';
	  console.log(content);
	  editor.addNode(node.name, node.input,  node.output, pos_x, pos_y, node.name, {}, content );

    }

  var transform = '';
  function showpopup(e) {
    e.target.closest(".drawflow-node").style.zIndex = "9999";
    e.target.children[0].style.display = "block";
    //document.getElementById("modalfix").style.display = "block";

    //e.target.children[0].style.transform = 'translate('+translate.x+'px, '+translate.y+'px)';
    transform = editor.precanvas.style.transform;
    editor.precanvas.style.transform = '';
    editor.precanvas.style.left = editor.canvas_x +'px';
    editor.precanvas.style.top = editor.canvas_y +'px';
    console.log(transform);

    //e.target.children[0].style.top  =  -editor.canvas_y - editor.container.offsetTop +'px';
    //e.target.children[0].style.left  =  -editor.canvas_x  - editor.container.offsetLeft +'px';
    editor.editor_mode = "fixed";

  }

   function closemodal(e) {
     e.target.closest(".drawflow-node").style.zIndex = "2";
     e.target.parentElement.parentElement.style.display  ="none";
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
      if(option == 'lock') {
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
    nav.appendChild(' ' + textNode);
    nav.classList.add('nav-text');
    menu.icon.split(' ').forEach(el => {icon.classList.add(el)})
    draggable.classList.add('drag-drawflow');
    draggable.setAttribute('ondragstart','drag(event)');
    draggable.setAttribute('draggable', true);
    draggable.setAttribute('data-node', JSON.stringify(menu));
    draggable.appendChild(icon);
    draggable.appendChild(nav);

    draggable.addEventListener('touchend', drop, false);
    draggable.addEventListener('touchmove', positionMobile, false);
    draggable.addEventListener('touchstart', drag, false );

    li.appendChild(draggable);
    flowmenu.appendChild(li);
  })}

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
        var parentdrawflow = document.elementFromPoint( mobile_last_move.touches[0].clientX, mobile_last_move.touches[0].clientY).closest("#drawflow");
        if(parentdrawflow != null) {
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
  const jsn = editor.export();
  if (!jsn.drawflow) return;
  if (!jsn.drawflow.Home) return;
  const flow = {};
  flow.bs = [];
  flow.bo = [];
  flow.bp = [];
  production = jsn.drawflow.Home.data;
  Object.getOwnPropertyNames(production).forEach(el => {
    let element = production[el],
      thing = {};
    thing.name = element.name;
    thing.config = {"classname":element.class};

    let sequence = [];
    for (output in element.outputs) {
      element.outputs[output].connections.forEach( conn => {
        let dest = production[conn.node],
        connection = {};
        connection.type = "call";
        connection.target = {"name": dest.name};
        sequence.push(connection);
      }

      )

    }
    if (sequence.length > 0) {
      thing.config.sequence = sequence;
    }

    if ((Object.getOwnPropertyNames(element.outputs).length > 0)&& (Object.getOwnPropertyNames(element.inputs).length == 0)) {
      // BS
      flow.bs.push(thing)
    } else if ((Object.getOwnPropertyNames(element.inputs).length > 0)&& (Object.getOwnPropertyNames(element.outputs).length == 0)) {
      // BO
      flow.bo.push(thing)
    } else {
      flow.bp.push(thing)
    }


  });

  console.log(flow);
}

document.onreadystatechange = function(event) {
    if (document.readyState === "complete") {
      const getComponentOptions = () => {
        const response = fetch('/csp/irisflow/api/components');
        response.then(res => res.json())
        .then(data => loadFlowMenu(data.data))
      }
      getComponentOptions();
    }
};
