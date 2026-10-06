import socket

server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_socket.bind(("localhost", 5000))
server_socket.listen(1)

print("Waiting for client...")
conn, addr = server_socket.accept()
print("Connected to:", addr)

while True:
    message = conn.recv(1024).decode()

    if message.lower() == "bye":
        print("Client disconnected.")
        break

    print("Client:", message)

    reply = input("Server: ")
    conn.send(reply.encode())

    if reply.lower() == "bye":
        break

conn.close()
server_socket.close()