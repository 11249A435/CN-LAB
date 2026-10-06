import socket

client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client_socket.connect(("localhost", 5000))

print("Connected to server.")

while True:
    message = input("Client: ")
    client_socket.send(message.encode())

    if message.lower() == "bye":
        break

    reply = client_socket.recv(1024).decode()
    print("Server:", reply)

    if reply.lower() == "bye":
        break

client_socket.close()