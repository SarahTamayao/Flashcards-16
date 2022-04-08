//
//  ViewController.swift
//  Flashcards
//
//  Created by Osoname Omonagbe on 2/26/22.
//


//
import UIKit

struct Flashcard{
    var question: String
    var answer: String
}

class ViewController: UIViewController {

    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var Backlabel: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
   
    @IBOutlet weak var card: UIView!
    
   
    
    //Array to hold our Flashcard
    var flashcards = [Flashcard]()
    
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
        
        //read saved flashcards
        readSavedFlashcards()
        
        //adding our initial flashcards if needed
        if flashcards.count == 0{
        updateFlashcard(question: "what's the capital of Brazil?", answer: "Brasilia")
        } else {
            updateLabels()
            updateNextPrevButtons()
        }
        
    }
    

    
    @IBAction func didTapOnFlashcard(_ sender: Any) {
        flipFlashcard()
    }
    func flipFlashcard(){
        //Move all the code from didTaponflashcard here
        frontLabel.isHidden = true
        UIView.transition(with: card, duration: 0.3, options: .transitionFlipFromRight) {
            self.frontLabel.isHidden = true
        }
    }
    
    @IBAction func didTapOnPrev(_ sender: Any) {
        currentIndex = currentIndex - 1
        
        //update labels
        updateLabels()
        //update buttons
        updateNextPrevButtons()
        bringFrontBack()
        animateCardIn()
    }
    
    @IBAction func didTapOnNext(_ sender: Any) {
        // Increase current index
        currentIndex = currentIndex + 1
        
        //update labels
        updateLabels()
        //update buttons
        updateNextPrevButtons()
        bringFrontBack()
        animateCardOut()
    }
    
    func updateFlashcard(question: String,  answer: String) {
        // Do stuff here
        let flashcard = Flashcard(question: question, answer: answer)
        frontLabel.text = flashcard.question
        Backlabel.text = flashcard.answer
        
        flashcards.append(flashcard)
        
        print("Added new flashcard")
        print("we now have \(flashcards.count) flashcards")
        // update current Index
        currentIndex = flashcards.count - 1
        print("Our current index is \(currentIndex)")
        
        updateNextPrevButtons()
        updateLabels()
        saveAllFlashcardsToDisk()
        bringFrontBack()
        
    }
    
    func bringFrontBack(){
        //bring the front label back.
        frontLabel.isHidden = false
    }
    
    func updateLabels(){
        let currentFlashcard = flashcards[currentIndex]
        frontLabel.text = currentFlashcard.question
        Backlabel.text = currentFlashcard.answer
    }
    func animateCardOut (){
        UIView.animate(withDuration: 0.3, animations: {
            self.card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)
        }, completion: { finished in
            
            // update labels
            self.animateCardIn()
            
            // run other animation
            self.animateCardIn()
        })
        
    }
    func animateCardIn(){
        
        // start on the right side (dont animate this)
        card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)
        
       // Animate card going to its original position
        UIView.animate(withDuration: 0.3){
            self.card.transform = CGAffineTransform.identity
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       let navigationController = segue.destination as! UINavigationController
        
        let creationController = navigationController.topViewController as! CreationViewController
        
        creationController.flashcardsController = self
        
    }
    

    func updateNextPrevButtons(){
        
        //Disable next button if at the end
        if currentIndex == flashcards.count - 1{
            nextButton.isEnabled = false
        }else {
            nextButton.isEnabled = true
        }
        
        //Disable prev button if at the beginning
        if currentIndex == 0 {
            prevButton.isEnabled = false
        } else {
            prevButton.isEnabled = true
        }
    }
    
    func saveAllFlashcardsToDisk(){
        
        // From flashcard array to dictionary array
        let dictionaryArray = flashcards.map { (card)  -> [String:String] in
            return ["question": card.question, "answer": card.answer] }
        
        // Save array on disk using userDefaults
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcard2")
        
    print(" Flashcards saved to UserDefaults")
            
       //save array on disk using UserDefaults
    //UserDefaults.standard.set(flashcards, forKey: "flashcards")
        
        
        
        }
    func readSavedFlashcards(){
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcard2") as? [[String:String]]{
            // in here we know for sure we have a dictionary array
    let savedCards = dictionaryArray.map { dictionary -> Flashcard  in
                return Flashcard (question: dictionary["question"]!, answer: dictionary["answer"]!)
            }
            
            //put all these cards in our flashcards array
            flashcards.append(contentsOf: savedCards)
        }
    }
    
}




