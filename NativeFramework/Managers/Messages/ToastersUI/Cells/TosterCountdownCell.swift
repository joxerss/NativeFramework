//
//  TosterCountdownCell.swift
//  SourceProject
//
//  Created by Artem Syrytsia on 21.07.2023.
//

import UIKit

typealias TosterCountdownCellCompletion = (ToasterModel?)->()

class TosterCountdownCell: UITableViewCell {

    // MARK: - Properties
    
    @IBOutlet private weak var conetentBGView: UIView!
    @IBOutlet private weak var circleView: RPCircularProgress!
    @IBOutlet private weak var countDownLabel: UILabel!
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var actionButton: UIButton!
    @IBOutlet private weak var crossButton: UIButton!
    
    private var toaster: ToasterModel?
    
    private var hideCompletion: TosterCountdownCellCompletion?
    private var crossCompletion: TosterCountdownCellCompletion?
    
    /// Notify every second for update countdown time.
    private var timer: Timer?
    private var countDownValue: Int = 0
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupAppearances()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        timer?.invalidate()
        timer = nil
        title.text = nil
        actionButton.setTitle(nil, for: .normal)
        crossButton.setTitle(nil, for: .normal)
        hideCompletion = nil
        crossCompletion = nil
        setupAppearances()
    }
    
    private func setupAppearances() {
        backgroundColor = .clear
        backgroundView?.backgroundColor = .clear
        
        selectionStyle = .none
        
        conetentBGView.backgroundColor = .white
        conetentBGView.roundCorners(radius: 10.0)
        title.textColor = .black
        title.font = .customFont(.interRegular, 14.0)
        title.numberOfLines = 0
        
        countDownLabel.textColor = .black
        countDownLabel.font = .customFont(.interRegular, 9.0)
        
        actionButton.titleLabel?.font = .customFont(.interRegular, 12.0)
        actionButton.backgroundColor = .black
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.setTitleColor(.white, for: .selected)
        actionButton.roundCorners(radius: 10.0)
        
        crossButton.setTitle("", for: .normal)
        crossButton.tintColor = .black
        crossButton.setImage(.init(named: "crossIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        crossButton.setImage(.init(named: "crossIcon")?.withRenderingMode(.alwaysTemplate), for: .selected)
        crossButton.roundCorners(radius: 10.0)
        
        circleView.backgroundColor = .clear
        circleView.roundedCorners = true
        circleView.thicknessRatio = 0.22
        circleView.trackTintColor = .black
        circleView.progressTintColor = .white
        circleView.innerTintColor = .clear
        circleView.clockwiseProgress = true
    }
    
    // MARK: - Public
    
    func setup(with toaster: ToasterModel,
               hideCompletion: TosterCountdownCellCompletion?,
               crossCompletion: TosterCountdownCellCompletion?) {
        self.toaster = toaster
        self.hideCompletion = hideCompletion
        self.crossCompletion = crossCompletion
        
        switch toaster.type {
        case .countDown(let text, let countDownTime, let action):
            title.text = text
            
            // Start count down timer (animation).
            circleView.updateProgress(1.0,
                                      animated: true,
                                      initialDelay: 0,
                                      duration: countDownTime + 1,
                                      completion: nil)
            
            actionButton.setTitle(action.titleAction, for: .normal)
            
            countDownValue = Int(countDownTime)
            countDownLabel.text = "\(countDownValue)"
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
                guard let `self` = self else {
                    return
                }
                
                if self.countDownValue > 0 {
                    self.countDownValue -= 1
                    self.countDownLabel.text = "\(countDownValue)"
                }
            }
            
        default:
            assertionFailure("🌁 The rest types has own cells. This one was created for text only.")
            return
        }
    }
    
    // MARK: - Actions
    
    @IBAction private func actionButton(_ sender: Any) {
        switch toaster?.type {
        case .countDown(_, _, let action):
            timer?.invalidate()
            action.completionAction()
            hideCompletion?(toaster)
        default:
            assertionFailure("🌁 The rest types has own cells. This one was created for text only.")
            return
        }
    }
    
    @IBAction private func crossAction(_ sender: Any) {
        timer?.invalidate()
        self.crossCompletion?(toaster)
    }
    
    
}
