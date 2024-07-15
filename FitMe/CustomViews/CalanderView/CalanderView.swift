import SwiftUI

struct CalanderView: View {
    
    
    @Binding var date: Date
    @Binding var isCalanderPresented: Bool

    var body: some View {
        loadView()
    }
    
    func loadView() -> some View {
        VStack(alignment: .trailing) {
            
            Button {
                isCalanderPresented.toggle()
            } label: {
                Text("Done")
                    .font(.system(size: 16, weight: .semibold))
            }.padding()

            DatePicker("", selection: $date, in: date..., displayedComponents: .date).datePickerStyle(GraphicalDatePickerStyle())
            
        }
    }
}


#Preview {
    CalanderView(date: .constant(Date()), isCalanderPresented: .constant(false))
}
