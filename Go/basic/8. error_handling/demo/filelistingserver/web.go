package main

import (
	"log"
	"net/http"
	_ "net/http/pprof" // 加下划线用于load一些帮助程序，但是不会直接引用pprof
	"os"

	"imooc.com/ccmouse/learngo/lang/errhandling/filelistingserver/filelisting"
)

// 统一错误处理

type appHandler func(writer http.ResponseWriter,
	request *http.Request) error

func errWrapper(
	handler appHandler) func(
	http.ResponseWriter, *http.Request) {
	return func(writer http.ResponseWriter,
		request *http.Request) {
		// panic
		defer func() {
			if r := recover(); r != nil {
				log.Printf("Panic: %v", r)
				http.Error(writer,
					http.StatusText(http.StatusInternalServerError),
					http.StatusInternalServerError)
			}
		}()

		err := handler(writer, request)

		if err != nil {
			log.Printf("Error occurred "+
				"handling request: %s",
				err.Error())

			// user error
			if userErr, ok := err.(userError); ok {
				http.Error(writer,
					userErr.Message(),
					http.StatusBadRequest)
				return
			}

			// system error
			code := http.StatusOK
			switch {
			case os.IsNotExist(err):
				code = http.StatusNotFound
			case os.IsPermission(err):
				code = http.StatusForbidden
			default:
				code = http.StatusInternalServerError
			}
			http.Error(writer,
				http.StatusText(code), code)
		}
	}
}

type userError interface {
	error
	Message() string
}

// type User struct {
// 	Name string `json:"name"`
// 	Age  int    `json:"age"`
// }

func main() {
	http.HandleFunc("/",
		errWrapper(filelisting.HandleFileList))

	// http.HandleFunc("/json", func(writer http.ResponseWriter, request *http.Request) {
	// 	user := User{
	// 		Name: "Desmond",
	// 		Age:  30,
	// 	}

	// 	userJSON, err := json.Marshal(user)
	// 	if err != nil {
	// 		http.Error(writer, err.Error(), http.StatusInternalServerError)
	// 		return
	// 	}
	// 	writer.Header().Set("Content-Type", "application/json")
	// 	writer.write(userJSON)
	// })

	// http.HandleFunc("/image", func(writer http.ResponseWriter, request *http.Request) {
	// 	image := path.Join("images", "golang.png")
	// 	http.ServeFile(writer, request, image)
	// })

	// http.HandleFunc("/html", func(writer http.ResponseWriter, request *http.Request) {
	// 	user := User{
	// 		Name: "Desmond",
	// 		Age:  30,
	// 	}
	// 	htmlFile := path.Join("templates", "index.html")
	// 	tmpl, err := template.ParseFiles(htmlFile)
	// 	if err != nil {
	// 		http.Error(writer, err.Error(), http.StatusInternalServerError)
	// 		return
	// 	}
	// 	if err := tmpl.Execute(writer, user); err != nil {
	// 		http.Error(writer, err.Error(), http.StatusInternalServerError)
	// 		return
	// 	}
	// })

	err := http.ListenAndServe(":8888", nil)
	if err != nil {
		panic(err)
	}
}
