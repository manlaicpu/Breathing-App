import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                NavigationLink(destination: BreathingExerciseView(breathingType: .calm)) {
                    ChoiceBoxView(title: "Calm")
                }
                NavigationLink(destination: BreathingExerciseView(breathingType: .boxBreathing)) {
                    ChoiceBoxView(title: "Box Breathing")
                }
                NavigationLink(destination: BreathingExerciseView(breathingType: .coffee)) {
                    ChoiceBoxView(title: "Coffee")
                }
            
            }
            .padding()
            .navigationBarTitle("Breathing Exercises")
            


        }
    }
}

struct ChoiceBoxView: View {
    var title: String
    
    var body: some View {
        Text(title)
            .font(.title)
            .foregroundColor(.white)
            .frame(width: 200, height: 100)
            .background(Color.blue)
            .cornerRadius(10)
    }
}

struct BreathingExerciseView: View {
    var breathingType: BreathingType
    
    @State private var timer: Timer?
    @State private var inhaleDuration: TimeInterval = 0
    @State private var exhaleDuration: TimeInterval = 0
    @State private var holdDuration: TimeInterval = 0
    @State private var sessionCount: Int = 0
    @State private var isCongratsVisible: Bool = false
    @State private var isExerciseInProgress: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text(breathingType.description)
                .font(.title)
                .multilineTextAlignment(.center)
            
            Button(action: {
                startBreathingExercise()
            }) {
                Text("Start Exercise")
                    .font(.title)
                    .foregroundColor(.white)
                    .frame(width: 200, height: 100)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            if isExerciseInProgress {
                CountdownView(inhaleDuration: inhaleDuration, exhaleDuration: exhaleDuration, holdDuration: holdDuration)
            }
            
            if isCongratsVisible {
                Text("Congrats!")
                    .font(.title)
                    .foregroundColor(.green)
            }
        }
        .padding()

        .onDisappear {
            stopBreathingExercise()
        }
    }
    
    private func startBreathingExercise() {
        switch breathingType {
        case .calm:
            inhaleDuration = 6
            holdDuration = 7
            exhaleDuration = 8
            
        case .boxBreathing:
            inhaleDuration = 4
            holdDuration = 4
            exhaleDuration = 4
            holdDuration = 4
        case .coffee:
            inhaleDuration = 6
            exhaleDuration = 2
    
        }
        
        sessionCount = 0
        isCongratsVisible = false
        isExerciseInProgress = true
        
        timer = Timer.scheduledTimer(withTimeInterval: inhaleDuration + exhaleDuration + holdDuration, repeats: true) { _ in
            sessionCount += 1
            
            if sessionCount >= 6 {
                stopBreathingExercise()
                isCongratsVisible = true
            }
        }
    }
    
    private func stopBreathingExercise() {
        timer?.invalidate()
        timer = nil
        isExerciseInProgress = false
    }
}

struct CountdownView: View {
    var inhaleDuration: TimeInterval
    var exhaleDuration: TimeInterval
    var holdDuration: TimeInterval
    
    @State private var countdown: TimeInterval = 0
    @State private var currentPhase: BreathingPhase = .inhale
    
    var body: some View {
        VStack(spacing: 20) {
            Text(currentPhase.description)
                .font(.title)
                .foregroundColor(.blue)
            
            Text("\(Int(countdown))")
                .font(.title)
                .foregroundColor(.black)
                .onAppear {
                    startCountdown()
                }
        }
    }
    
    private func startCountdown() {
        switch currentPhase {
        case .inhale:
            countdown = inhaleDuration
        case .hold:
            countdown = holdDuration
        case .exhale:
            countdown = exhaleDuration
        }
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            countdown -= 1
            
            if countdown <= 0 {
                timer.invalidate()
                
                switch currentPhase {
                case .inhale:
                    currentPhase = .hold
                case .hold:
                    currentPhase = .exhale
                case .exhale:
                    currentPhase = .inhale
                
                }
                
                startCountdown()
            }
        }
    }
}

enum BreathingPhase {
    case inhale
    case exhale
    case hold
    
    var description: String {
        switch self {
        case .inhale:
            return "Inhale"
        case .hold:
            return "Hold"
        case .exhale:
            return "Exhale"

        }
    }
}



enum BreathingType {
    case calm
    case boxBreathing
    case coffee
    
    var description: String {
        switch self {
        case .calm:
            return "Calm breathing exercise description"
        case .boxBreathing:
            return "Box breathing exercise description"
        case .coffee:
            return "Coffee breathing exercise description"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



