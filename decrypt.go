package main

import (
	"crypto/aes"
	"crypto/cipher"
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
)

func decrypt(ciphertext []byte, key []byte) []byte {
	block, err := aes.NewCipher(key)
	if err != nil {
		panic(err)
	}

	// Extract IV from ciphertext
	iv := ciphertext[:aes.BlockSize]
	ciphertext = ciphertext[aes.BlockSize:]

	// Return a decrypted stream
	stream := cipher.NewCFBDecrypter(block, iv)

	// Decrypt bytes from ciphertext to plaintext
	stream.XORKeyStream(ciphertext, ciphertext)

	return ciphertext
}

func decryptFilesInFolder(folderPath, keystring string) error {
	// Get a list of all files and directories in the folder
	files, err := ioutil.ReadDir(folderPath)
	if err != nil {
		return err
	}

	key := []byte(keystring)

	// Decrypt each file
	for _, file := range files {
		filePath := filepath.Join(folderPath, file.Name())

		// If it's a directory, recursively decrypt its contents
		if file.IsDir() {
			err := decryptFilesInFolder(filePath, keystring)
			if err != nil {
				fmt.Printf("Error decrypting files in directory %s: %v\n", filePath, err)
			}
			continue
		}

		// Skip non-encrypted files
		if !hasEncryptedExtension(file.Name()) {
			continue
		}

		// Read the encrypted file content
		ciphertext, err := ioutil.ReadFile(filePath)
		if err != nil {
			fmt.Printf("Error reading file %s: %v\n", filePath, err)
			continue
		}

		// Decrypt the file content
		plaintext := decrypt(ciphertext, key)

		// Write the decrypted data back to the file
		decryptedFilePath := removeEncryptedExtension(filePath)
		err = ioutil.WriteFile(decryptedFilePath, plaintext, 0777)
		if err != nil {
			fmt.Printf("Error writing decrypted file %s: %v\n", decryptedFilePath, err)
		}
	}

	return nil
}

func hasEncryptedExtension(filename string) bool {
	return filepath.Ext(filename) == ".encrypted"
}

func removeEncryptedExtension(filename string) string {
	return filename[:len(filename)-len(".encrypted")]
}

func main() {
	if len(os.Args) < 3 {
		fmt.Println("Usage: programname <key> <folderpath>")
		os.Exit(1)
	}

	key := []byte(os.Args[1])
	folderPath := os.Args[2]



	err := decryptFilesInFolder(folderPath, string(key))
	if err != nil {
		fmt.Println("Error decrypting files:", err)
		return
	}

	fmt.Println("Decryption complete for files in", folderPath)
}
