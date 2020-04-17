
import UIKit
class CustomCell: UITableViewCell {
    let imgcell:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 10
        img.clipsToBounds = true
        return img
    }()
    let lblTitle:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let lblDescription:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(imgcell)
        self.contentView.addSubview(lblTitle)
        self.contentView.addSubview(lblDescription)
        
        imgcell.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        imgcell.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5).isActive = true
        imgcell.contentMode = .scaleAspectFill
        imgcell.widthAnchor.constraint(equalToConstant:70).isActive = true
        imgcell.heightAnchor.constraint(equalToConstant:70).isActive = true
        
        lblTitle.topAnchor.constraint(equalTo:self.imgcell.bottomAnchor).isActive = true
        lblTitle.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true
        lblTitle.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10).isActive = true
        
        lblDescription.topAnchor.constraint(equalTo:self.lblTitle.bottomAnchor).isActive = true
        lblDescription.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true
        lblDescription.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10).isActive = true
        lblDescription.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
