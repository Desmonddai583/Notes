function anonymous(data) {
    let str = ''
    with(data) {
        str = `<!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Document</title>
    </head>
    <body>
        `
        arr.forEach(item => {
            str += `
                ${item}
            `
        })
        str += `
    </body>  
    </html>`
    }
    return str
}