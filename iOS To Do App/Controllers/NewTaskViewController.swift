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
    @IBOutlet weak var deadlinelabel: UILabel!
    
    private var subscribers = Set<AnyCancellable>()
    
    var taskToEdit: Task?
    weak var delagate: TasksVCDelegate?

    
    @Published private var taskString: String?
    @Published private var deadline: Date?
    /* ------------------------------------------------------------------ */

    private lazy var calenderView : CalendarView = {
        let view = CalendarView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
     override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupGesture()
        observeForm()
        observeKeyboard()
    }
    
    private func setupView()  {
        backgroundView.backgroundColor = UIColor.init(white: 0.3, alpha: 0.4)
        containerViewBottomConstraint.constant = -containerView.frame.height
        
        if let taskToEdit = self.taskToEdit {
            newTaskTextField.text = taskToEdit.title
            taskString = taskToEdit.title
            deadline = taskToEdit.deadline
            saveButton.setTitle("Update", for: .normal)
            //Update Calendar
        }
   }
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dissMissViewController))
        //tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dissMissViewController() {
        dismiss(animated: true, completion: nil)
        print("dismiss keyboard")
     }
    
    private func dissMissCalendarView(completion: () -> Void ) {
        calenderView.removeFromSuperview()
        completion()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        newTaskTextField.becomeFirstResponder()
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
    
    func showCalender() {
        view.addSubview(calenderView)
        NSLayoutConstraint.activate([
            calenderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calenderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calenderView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
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
        
        $deadline.sink { date in
            self.deadlinelabel.text = date?.toString() ?? ""
        }.store(in: &subscribers)
        
        
    }
    
    
    @IBAction func calendarButtonClicked(_ sender: Any) {
        newTaskTextField.resignFirstResponder()
        showCalender()
    }
    
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        guard let taskString = taskString else {
            return
        }
        
        let task = Task(title: taskString, deadline: deadline)
        
        delagate?.didAddTask(task)
    }
} 

extension NewTaskViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if calenderView.isDescendant(of: view){
            if touch.view?.isDescendant(of: calenderView) == false {
              //  dissMissCalendarView { [unowned self] in
           //         self.newTaskTextField.becomeFirstResponder()
                    print("dissmiss calendar")
            //    }
                }
            return false
                // if calendarview is added as subview, then when its tapped dont dissmiss it.
        }
        return true }
}

extension NewTaskViewController: CalanderViewDelegate {
    func calendarViewDidSelecDate(date: Date) {
        dissMissCalendarView { [unowned self] in
            self.newTaskTextField.becomeFirstResponder()
            deadline = date

        }
    }
    
    func calendarViewDidTapRemoveButton() {
        dissMissCalendarView {
            self.newTaskTextField.becomeFirstResponder()
            self.deadline = nil
        }
    }
    
    
}
