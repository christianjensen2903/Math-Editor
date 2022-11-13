import logo from './logo.svg';
import './App.css';
import React, { useEffect, useRef, useState } from 'react';

import ReactQuill from 'react-quill';
import 'react-quill/dist/quill.snow.css';


function App() {
  const [value, setValue] = useState('');

  const ws = useRef(null);

  useEffect(() => {

    let uniqueId = Date.now().toString(36) + Math.random().toString(36).substring(2);
    console.log("run useEffect");

    ws.current = new WebSocket('ws://localhost:8000/ws/' + uniqueId);

    console.log("useEffect");
    ws.current.onopen = function () {
      console.log(uniqueId);
      console.log('WebSocket Client Connected');
    };

    ws.current.onmessage = function (message) {
      console.log(uniqueId)
      console.log(message);
    };
  
    ws.current.onerror = function (error) {
      console.log(error);
    };

  }, []);


  // onChange expects a function with these 4 arguments
  function handleChange(content, delta, source, editor) {
    if (!ws.current) {
      return;
    }
    ws.current.send(JSON.stringify(delta));
    setValue(editor.getContents());
  }
  
  

  return (
    <div className="App">
      <header className="App-header">
        <ReactQuill theme="snow" value={value} onChange={handleChange} />;
      </header>
    </div>
  );
}

export default App;
