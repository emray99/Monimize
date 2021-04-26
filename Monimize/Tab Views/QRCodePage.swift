//
//  QRCodePage.swift
//  Monimize
//
//  Created by Ray Liu on 4/26/21.
//

import SwiftUI
import AVFoundation
 
struct ScanQRBarcode: View {
   
    @State var barcode: String = ""
    @State var lightOn: Bool = false
   
    var body: some View {
        VStack {
            // Show barcode scanning camera view if no barcode is present
            if barcode.isEmpty {
                /*
                 Display barcode scanning camera view on the background layer because
                 we will display the results on the foreground layer in the same view.
                 */
                ZStack {
                    /*
                     BarcodeScanner displays the barcode scanning camera view, obtains the barcode
                     value, and stores it into the @State variable 'barcode'. When the @State value
                     changes,the view invalidates its appearance and recomputes this body view.
                    
                     When this body view is recomputed, 'barcode' will not be empty and the
                     else part of the if statement will be executed, which displays barcode
                     processing results on the foreground layer in this same view.
                     */
                    BarcodeScanner(code: self.$barcode)
                   
                    // Display the flashlight button view
                    FlashlightButtonView(lightOn: self.$lightOn)
                   
                    /*
                     Display the scan focus region image to guide the user during scanning.
                     The image is constructed in ScanFocusRegion.swift upon app launch.
                     */
                    //scanFocusRegionImage
                }
            } else {
                // Show QR barcode processing results
                qrBarcodeProcessingResults
            }
        }   // End of VStack
            .onDisappear() {
                self.lightOn = false
        }
    }
   
    var qrBarcodeProcessingResults: some View {
       
        if barcode.hasPrefix("http") {
            return AnyView(WebView(url: self.barcode))
        }
        return AnyView(
            VStack {
                Image(systemName: "exclamationmark.triangle")
                    .imageScale(.large)
                    .font(Font.title.weight(.medium))
                    .foregroundColor(.red)
                    .padding()
                Text("Invalid QR Barcode!\n\nThe barcode scanned with UPC \(self.barcode) is not a QR barcode!")
                    .fixedSize(horizontal: false, vertical: true)   // Allow lines to wrap around
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .background(Color(red: 1.0, green: 1.0, blue: 240/255))     // Ivory color
        )
    }
}
 
struct ScanQRBarcode_Previews: PreviewProvider {
    static var previews: some View {
        ScanQRBarcode()
    }
}
 
