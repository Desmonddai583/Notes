const express = require('express');

const app = express();
app.all('*', (req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Headers', 'Content-Type');
  res.header('Access-Control-Allow-Methods', '*');
  res.header('Content-Type', 'application/json;charset=utf-8');
  next();
});
app.get('/category', (req, res) => {
  res.json({
    menuList: [
        {pid:-1,name:'服装',id:1,auth:'clothing'},
        {pid:1,name:'男装',id:4,auth:'men-wear'},
        {pid:1,name:'女装',id:5,auth:'women-wear'},
        {pid:5,name:'裙子',id:6,auth:'skirt'},
        {pid:4,name:'衬衫',id:7,auth:'shirt'},
        // {pid:-1,name:'酒类',id:2,auth:'liquor'},
        // {pid:-1,name:'医药',id:3,auth:'medicine'},
    ]
  });
});
app.listen(3000); // http://localhost:3000/category