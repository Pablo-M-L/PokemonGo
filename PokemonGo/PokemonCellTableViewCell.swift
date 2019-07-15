//
//  PokemonCellTableViewCell.swift
//  PokemonGo
//
//  Created by admin on 15/07/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class PokemonCellTableViewCell: UITableViewCell {

    @IBOutlet weak var imagenPokemon: UIImageView!
    @IBOutlet weak var labelSup: UILabel!
    @IBOutlet weak var labelInf: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
