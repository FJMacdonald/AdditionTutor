//
//  ContentView.swift
//  AdditionTutor
//
//  Created by Francesca MACDONALD on 2023-08-21.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    
    @State private var audioPlayer: AVAudioPlayer!
    @State private var number1 = 0
    @State private var number2 = 0
    @State private var image1 = 0
    @State private var image2 = 0
    @State private var additionRow1 = ""
    @State private var additionRow2 = ""
    @State private var message = "Welcome to Addition Tutor!"
    @State private var answer = ""
    @State private var questionsAttempted = 0
    @State private var correctAnsweres = 0
    @FocusState private var textFieldIsFocused
    let emojiArray = ["🦎", "🐳", "🐙", "🦔", "🦉", "🪼", "🦚"]
    let correctStrings = ["Good job!", "Well done!", "Correct!", "You are Right!", "Super!", "Nice!"]
    let incorrectStrings = ["Oops!", "Better luck next time", "Not quite", "Try again", "More practice", "Sorry, that's wrong"]
    
    
    
    var body: some View {
        VStack (alignment: .center) {
            HStack {
                VStack {
                    Text("Questions attempted: \(questionsAttempted)")
                    Text("Correct answeres: \(correctAnsweres)")
                }
                Text(questionsAttempted > 0 ? "Score: \(Int(Double(correctAnsweres)/Double(questionsAttempted) * 100.0)) %" : "")
            }
            Spacer()
            
            Text(message)
                .font(.title)
                .multilineTextAlignment(.center)
                .frame(height: 280)
            Text(additionRow1)
                .font(.system(size: 60))
                .frame(height: 80)
            Image(systemName: "plus")
                .resizable()
                .frame(width: 50, height: 50)
            Text(additionRow2)
                .font(.system(size: 60))
                .font(.largeTitle)
                .frame(height: 80)
            
            
            HStack {
                Text("\(number1) + \(number2) = ")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .frame(height: 80)
                    .minimumScaleFactor(0.5)
                TextField("", text: $answer)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 50)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray, lineWidth: 2)
                        
                    }
                    .submitLabel(.done)
                    .keyboardType(.numberPad)
                    .focused($textFieldIsFocused)
                    .onSubmit {
                        let index = Int.random(in: 0...correctStrings.count-1)
                        questionsAttempted += 1
                        if Int(answer) == number1 + number2 {
                            message = correctStrings[index]
                            correctAnsweres += 1
                            playSound(soundFile: "word-guessed")
                        } else {
                            message = incorrectStrings[index]
                            playSound(soundFile: "word-not-guessed")
                        }
                        answer = ""
                        setupAddition()
                    }
                
            }
            Spacer()
        }
        .onAppear(perform: setupAddition)
    }
    func setupAddition() {
        number1 = Int.random(in: 1...5)
        number2 = Int.random(in: 1...5)
        image1 = Int.random(in: 0...emojiArray.count-1)
        image2 = Int.random(in: 0...emojiArray.count-1)
        additionRow1 = String.init(repeating: emojiArray[image1], count: number1)
        additionRow2 = String.init(repeating: emojiArray[image2], count: number2)
        
        
    }
    func playSound(soundFile: String) {
        guard let soundFile = NSDataAsset(name: soundFile) else {
            print("😡 Could not read sound file")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
        } catch {
            print("😡 Could not create audio player")
        }
        audioPlayer.play()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
