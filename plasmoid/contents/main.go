package main

import (
	"fmt"
	"io"
	"net/http"
	"os"
	"strconv"
)

func main() {
	fmt.Println("Disclaimer:")
	fmt.Println("The authors do not own any of the music provided.")
	fmt.Println("This is a passion project and is not affiliated with Nintendo whatsoever.")
	fmt.Println("Music sampled is owned by Nintendo Co., Ltd and composed by Kazumi Totaka.")
	fmt.Println()
	fmt.Println("The Nook Plasmoid was inspired by the Nook Chrome-Extension:")
	fmt.Println("https://www.github.com/matlsn/nook")
	fmt.Println("https://chrome.google.com/webstore/detail/nook/gndfjlldkaonpbpdagdnpgobcbgcpdah")
	fmt.Println()

	games := [7]string{"population-growing", "wild-world", "wild-world-rainy", "wild-world-snowy", "new-leaf", "new-leaf-rainy", "new-leaf-snowy"}

	os.Mkdir("sound", 0777)
	for _, game := range games {
		os.Mkdir("sound/"+game, 0777)
		for i := 1; i <= 12; i++ {
			url := "https://s3.us-east-2.amazonaws.com/chrome-nook/" + game
			download(url+"/"+strconv.Itoa(i)+"am.ogg", "sound/"+game+"/"+strconv.Itoa(i)+"am.ogg")
			download(url+"/"+strconv.Itoa(i)+"pm.ogg", "sound/"+game+"/"+strconv.Itoa(i)+"pm.ogg")
		}
	}
}

func download(url, filename string) (err error) {
	fmt.Println("Downloading ", url, " to ", filename)

	resp, err := http.Get(url)
	if err != nil {
		return
	}
	defer resp.Body.Close()

	f, err := os.Create(filename)
	if err != nil {
		return
	}
	defer f.Close()

	_, err = io.Copy(f, resp.Body)
	return
}
