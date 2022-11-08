html = """
<!DOCTYPE html>
<html>
    <head>
        <title>Math Notebook</title>
    </head>
    <body>
        <h1>Math Notebook</h1>
        <form action="" onsubmit="runBlock(event)">
            <select name="cell_type" id="cell_type">
            <option value="math">Math</option>
            <option value="python">Python</option>
            <option value="markdown">Markdown</option>
            </select>
            <input type="text" id="content" autocomplete="off"/>
            <button>Run</button>
        </form>
        <p id="result"></p>
        <script>
            var ws = new WebSocket("ws://localhost:8000/ws");
            

            const loadNotebook = async () => {
                const response = await fetch("http://localhost:8000/load_notebook");
                const data = await response.json();
                console.log(data);
                document.getElementById("result").innerHTML = data.result;
                document.getElementById("cell_type").value = data.type;
                document.getElementById("content").value = data.content;
            };


            window.onload = loadNotebook;



            ws.onmessage = function(event) {
                data = JSON.parse(event.data)[0];
                document.getElementById("result").innerHTML = data.result;
                document.getElementById("cell_type").value = data.type;
                document.getElementById("content").value = data.content;
            };

            var timeout=setInterval(update,500);

            function update() {
                var cell_type = document.getElementById('cell_type').value;
                var content = document.getElementById('content').value;
                ws.send(JSON.stringify([{
                    type: "math",
                    content: content,
                    result: null,
                    last_ran: null,
                    last_calculated: null
                }]));
            }

            function runBlock(event) {
                var cell_type = document.getElementById('cell_type').value
                var content = document.getElementById("content").value
                ws.send(JSON.stringify([{
                    type: "math",
                    content: content,
                    result: null,
                    last_ran: Date.now(),
                    last_calculated: null
                }]));
                event.preventDefault()
            }
        </script>
    </body>
</html>
"""