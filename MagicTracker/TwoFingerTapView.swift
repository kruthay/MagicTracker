//
//  TwoFingerTapView.swift
//  MagicTracker
//
//  Created by Kruthay Kumar Reddy Donapati on 11/19/23.
//

import SwiftUI

struct TwoFingerTapView: UIViewRepresentable
{
    var tapCallback: (UITapGestureRecognizer) -> Void

    typealias UIViewType = UIView

    func makeCoordinator() -> TwoFingerTapView.Coordinator
    {
        Coordinator(tapCallback: self.tapCallback)
    }

    func makeUIView(context: Context) -> UIView
    {
        let view = UIView()
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(sender:)))
       
        /// Set number of touches.
        doubleTapGestureRecognizer.numberOfTouchesRequired = 2
       
        view.addGestureRecognizer(doubleTapGestureRecognizer)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context)
    {
    }

    class Coordinator
    {
        var tapCallback: (UITapGestureRecognizer) -> Void

        init(tapCallback: @escaping (UITapGestureRecognizer) -> Void)
        {
            self.tapCallback = tapCallback
        }

        @objc func handleTap(sender: UITapGestureRecognizer)
        {
            self.tapCallback(sender)
        }
    }
}
