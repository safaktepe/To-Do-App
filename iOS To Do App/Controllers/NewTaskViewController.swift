//
//  NewTaskViewController.swift
//  iOS To Do App
//
//  Created by Mert Şafaktepe on 4.05.2022.
//
import Combine
import UIKit

class NewTaskViewController: UIInputViewController {
    @IBOutlet weak var newTaskTextField: UITextField!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var saveButton: UIButton!
    
    private var subscribers = Set<AnyCancellable>()
    @Published private var taskString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        observeForm()
        setupGesture()
        observeKeyboard()
    }
    
    private func setupView()  {
        backgroundView.backgroundColor = UIColor.init(white: 0.3, alpha: 0.4)
        containerViewBottomConstraint.constant = -containerView.frame.height
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        newTaskTextField.becomeFirstResponder()
    }
    
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dissMissViewController))
        view.addGestureRecognizer(tapGesture)
    }
    
    //----- Keyboard activities. -------
    private func observeKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let keyboardHeight = getKeyboardHeight(notification: notification)
        
        //Little bounce animation
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: { [unowned self] in
            self.containerViewBottomConstraint.constant = keyboardHeight - (200 + 8) //200 -> View's height and 8 is margin.
            self.view.layoutIfNeeded()
        }, completion: nil)
        //End of animation
    }
    @objc func keyboardWillHide(_ notification: Notification) {
       containerViewBottomConstraint.constant = -containerView.frame.height
     }
    
    private func getKeyboardHeight(notification: Notification) -> CGFloat {
        guard let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else { return 0 }
        return keyboardHeight
    }
    
   @objc private func dissMissViewController() {
        dismiss(animated: true, completion: nil)
    }
    // -----   End of keyboard codes. ------
    
    
    private func observeForm() {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification).map { (notification) -> String? in
            return(notification.object as? UITextField)?.text
        }.sink { [unowned self] (text) in
            self.taskString = text
            }.store(in: &subscribers)
        $taskString.sink { [unowned self] (text) in
            self.saveButton.isEnabled = text?.isEmpty == false
        }.store(in: &subscribers)
        
        
    }
    
}
