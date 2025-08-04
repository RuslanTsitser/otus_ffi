package main

/*
#include <stdint.h>
*/
import "C"
import (
	"encoding/json"
	"fmt"
	"net/http"
)

// Response структура для JSON-ответа
type Response struct {
	Message string `json:"message"`
}

// runServer запускает HTTP-сервер на указанном порту
func runServer(port int) {
	http.HandleFunc("/ping", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		resp := Response{Message: "pong"}
		json.NewEncoder(w).Encode(resp)
	})
	http.HandleFunc("/data", func(w http.ResponseWriter, r *http.Request) {
		if r.Method != http.MethodPost {
			http.Error(w, "Use POST", http.StatusMethodNotAllowed)
			return
		}
		var req struct {
			Name string `json:"name"`
			Age  int    `json:"age"`
		}
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			http.Error(w, "Invalid JSON: "+err.Error(), http.StatusBadRequest)
			return
		}
		message := fmt.Sprintf("Привет, %s! Тебе %d лет.", req.Name, req.Age)
		json.NewEncoder(w).Encode(Response{Message: message})
	})

	addr := fmt.Sprintf(":%d", port)
	fmt.Printf("Go server listening on %s...\n", addr)
	http.ListenAndServe(addr, nil)
}

//export StartServer
func StartServer(port C.int) {
	// Запуск сервера в отдельной goroutine
	go runServer(int(port))
}

func main() {}
