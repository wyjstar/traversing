package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	// "net/url"
	"bytes"
	"os"
	"strings"
)

var servers map[string]string

func httpPostRedirect(keyName string, w http.ResponseWriter, req *http.Request) {
	req.ParseForm()
	data := req.Form
	fmt.Println(req.URL.String(), data)

	serverID := strings.Split(data.Get(keyName), "_")[1]
	serverURL, exists := servers[serverID]
	if !exists {
		fmt.Println("server id is error!", serverID)
		return
	}

	url := serverURL + req.URL.String()
	resp, err := http.PostForm(url, data)
	if err != nil {
		fmt.Println(err)
		return
	}
	defer resp.Body.Close()

	result, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		fmt.Println(err)
		return
	}

	if err != nil {
		fmt.Println(err)
		return
	}

	fmt.Println(" url:", url, "server:", serverID,
		"post:", req.Form, "result:", string(result))
	w.Write(result)
}

func lenovohttpPostRedirect(w http.ResponseWriter, req *http.Request) {
	req.ParseForm()
	data := req.Form
	fmt.Println(req.URL.String(), data)
	transdata := data.Get("transdata")

	index := strings.Index(transdata, "exorderno")
	serveridBegin := strings.Index(transdata[index:], ":\"") + index + 2
	serveridEnd := strings.Index(transdata[serveridBegin:], "\"") + serveridBegin
	serverID := strings.Split(transdata[serveridBegin:serveridEnd], "_")[1]

	serverURL, exists := servers[serverID]
	if !exists {
		fmt.Println("server id is error!", serverID)
		return
	}

	url := serverURL + req.URL.String()
	resp, err := http.PostForm(url, data)
	if err != nil {
		fmt.Println(err)
		return
	}
	defer resp.Body.Close()

	result, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		fmt.Println(err)
		return
	}

	if err != nil {
		fmt.Println(err)
		return
	}

	fmt.Println(" url:", url, "server:", serverID,
		"post:", req.Form, "result:", string(result))
	w.Write(result)
}

func uchttpPostRedirect(w http.ResponseWriter, req *http.Request) {
	req.ParseForm()
	bodydata := make([]byte, 5120)
	bodyLen, _ := req.Body.Read(bodydata)
	jsondata := string(bodydata)

	fmt.Println(req.URL.String(), jsondata)

	index := strings.Index(jsondata, "cpOrderId")
	serveridBegin := strings.Index(jsondata[index:], ":\"") + index + 2
	serveridEnd := strings.Index(jsondata[serveridBegin:], "\"") + serveridBegin
	serverID := strings.Split(jsondata[serveridBegin:serveridEnd], "_")[1]

	serverURL, exists := servers[serverID]
	if !exists {
		fmt.Println("server id is error!", serverID)
		return
	}

	url := serverURL + req.URL.String()
	resp, err := http.Post(url, "application/json", bytes.NewBuffer(bodydata[:bodyLen]))
	if err != nil {
		fmt.Println(err)
		return
	}
	defer resp.Body.Close()

	result, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		fmt.Println(err)
		return
	}

	if err != nil {
		fmt.Println(err)
		return
	}

	fmt.Println(" url:", url, "server:", serverID,
		"body:", jsondata, "result:", string(result))
	w.Write(result)
}

func httpHanle(keyName string) func(w http.ResponseWriter, req *http.Request) {
	return func(w http.ResponseWriter, req *http.Request) {
		httpPostRedirect(keyName, w, req)
	}
}

func help() {
	servers := make(map[string]string)
	servers["65"] = "http://192.168.1.65"
	servers["67"] = "http://192.168.1.67"
	byte, err := json.Marshal(&servers)
	if err != nil {
		fmt.Println(err)
	}

	fout, err := os.Create("servers.json")
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	defer fout.Close()
	fout.Write(byte)
	fmt.Println("generate servers.json success!")
}

func main() {
	if len(os.Args) > 1 {
		help()
		os.Exit(1)
	}

	fin, err := os.Open("servers.json")
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	defer fin.Close()

	buf := make([]byte, 1024*512)
	n, err := fin.Read(buf)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	err = json.Unmarshal(buf[:n], &servers)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	fmt.Println(string(buf[:n]), servers)
	fmt.Println("start...")

	http.HandleFunc("/huaweipay", httpHanle("requestId"))
	http.HandleFunc("/baidupay", httpHanle("CooperatorOrderSerial"))
	http.HandleFunc("/meizupay", httpHanle("cp_order_id"))
	http.HandleFunc("/lenovopay", lenovohttpPostRedirect)
	http.HandleFunc("/xmpay", httpHanle("cpOrderId"))
	http.HandleFunc("/ucpay", uchttpPostRedirect)

	http.ListenAndServe(":40013", nil)
}
