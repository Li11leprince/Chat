import SwiftUI
import OrderedCollections

struct Message: Identifiable, Hashable {
    let id = UUID()
    let text: String
    let isUser: Bool
    let timestamp: Date // Добавляем метку времени
    
    static var mock: [Message] = {
        var messages: [Message] = []
        for i in 1...300 {
            let messageText = "Сообщение номер \(i)"
            let message = Message(text: messageText, isUser: i % 2 == 0, timestamp: Date().addingTimeInterval(-Double(i * 60 * 60)))
            messages.append(message)
        }
        return messages
    }()
}

struct ChatView: View {
    @State private var messages: OrderedSet<Message> = []
    @State private var newMessage: String = ""
    @State private var searchText: String = ""
    @State private var foundMessageID: UUID?
    @State private var currentTimestamp: Date? // Время последнего видимого сообщения

    var body: some View {
        VStack {
            // Search bar
            HStack {
                TextField("Поиск сообщения", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(height: 40)
                Button(action: searchMessageOnServer) {
                    Text("Поиск")
                        .padding(.horizontal)
                }
                .disabled(searchText.isEmpty)
            }
            .padding()

            // Chat messages list
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(messages) { message in
                            MessageRow(message: message)
                                .id(message.id) // Указываем ID для каждого сообщения
                        }
                    }
                    .padding()
                    .onAppear {
                        // Загружаем предыдущие сообщения, когда дошли до верхней границы
                        if let firstMessage = messages.first {
                            if let currentTimestamp = currentTimestamp, currentTimestamp > firstMessage.timestamp {
                                loadPreviousMessages()
                            }
                        }
                    }

                }
            }

            // Input field for new messages
            HStack {
                TextField("Написать сообщение...", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minHeight: 30)
                
                Button(action: sendMessage) {
                    Text("Отправить")
                        .padding(.horizontal)
                }
                .disabled(newMessage.isEmpty)
            }
            .padding()
        }
        .onAppear(perform: loadInitialMessages)
    }
    
    // Simulate sending a new message
    func sendMessage() {
        let newMessageObject = Message(text: newMessage, isUser: true, timestamp: Date())
        messages.append(newMessageObject)
        newMessage = ""
    }

    // Simulate search on the server
    func searchMessageOnServer() {
        // Имитируем задержку для поиска на сервере
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            // На сервере нашли сообщение с меткой времени
            let foundMessage = Message(text: "Найденное сообщение", isUser: false, timestamp: Date().addingTimeInterval(-60*60*24*30)) // 30 дней назад
            let adjacentMessages = [
                Message(text: "Сообщение до найденного", isUser: false, timestamp: foundMessage.timestamp.addingTimeInterval(-60*60)),
                Message(text: "Сообщение после найденного", isUser: true, timestamp: foundMessage.timestamp.addingTimeInterval(60*60))
            ]
            
            DispatchQueue.main.async {
                // Добавляем новые сообщения до и после найденного
                messages.append(contentsOf: adjacentMessages)
                messages.append(foundMessage)
                
                // Прокрутка к найденному сообщению
                foundMessageID = foundMessage.id
            }
        }
    }
    
    // Simulate loading previous messages from the server
    func loadPreviousMessages() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            // Имитируем получение предыдущих сообщений
            let previousMessages = [
                Message(text: "Старое сообщение 1", isUser: false, timestamp: Date().addingTimeInterval(-60*60*24*40)),
                Message(text: "Старое сообщение 2", isUser: false, timestamp: Date().addingTimeInterval(-60*60*24*35))
            ]
            
            DispatchQueue.main.async {
                // Вставляем старые сообщения в начало массива
                messages.append(contentsOf: previousMessages)
            }
        }
    }

    // Load initial messages
    func loadInitialMessages() {
        // Имитируем начальную загрузку сообщений
        messages.append(contentsOf: (Message.mock.reversed()[0...20]).reversed())
        currentTimestamp = messages.last?.timestamp
        let reactions = ["👍", "❤️", "😂", "😮", "😢"]
        for emoji in reactions {
            print(emoji)
        }
    }
}

struct MessageRow: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
            }
            VStack(alignment: .leading) {
                Text(message.text)
                    .padding()
                    .background(message.isUser ? Color.blue : Color.gray.opacity(0.2))
                    .foregroundColor(message.isUser ? Color.white : Color.black)
                    .cornerRadius(10)
                Text("\(message.timestamp, formatter: dateFormatter)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            if !message.isUser {
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, alignment: message.isUser ? .trailing : .leading)
    }
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
