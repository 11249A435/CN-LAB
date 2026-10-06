import socket

server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.bind(("localhost", 5000))
server.listen(1)

print("Waiting for client...")
conn, addr = server.accept()
print("Connected:", addr)

filename = conn.recv(1024).decode()

try:
    with open(filename, "rb") as file:
        conn.send(b"OK")
        data = file.read(1024)

        while data:
            conn.send(data)
            data = file.read(1024)

    print("File sent successfully.")

except FileNotFoundError:
    conn.send(b"ERROR")
    print("File not found.")

conn.close()
server.close()