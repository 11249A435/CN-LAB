import socket

client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client.connect(("localhost", 5000))

filename = input("Enter file name: ")
client.send(filename.encode())

response = client.recv(1024)

if response == b"OK":
    with open("received_" + filename, "wb") as file:
        while True:
            data = client.recv(1024)

            if not data:
                break

            file.write(data)

    print("File received successfully.")

else:
    print("File not found on server.")

client.close()