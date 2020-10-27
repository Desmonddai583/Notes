const express = require('express');
const app = express();
app.listen(4444);

app.use(express.static(__dirname));

app.get('/download', (req, res) => {
    res.download('a.pdf')
})