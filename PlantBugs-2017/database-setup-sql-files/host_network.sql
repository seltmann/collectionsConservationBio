DROP TABLE IF EXISTS `host_network`;
CREATE TABLE IF NOT EXISTS `host_network` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `h_family` varchar(40) DEFAULT NULL,
  `h_genus` varchar(40) DEFAULT NULL,
  `h_species` varchar(40) DEFAULT NULL,
  `i_family` varchar(40) DEFAULT NULL,
  `i_tribe` varchar(40) DEFAULT NULL,
  `i_genus` varchar(40) DEFAULT NULL,
  `i_species` varchar(40) DEFAULT NULL,
  `i_family_id` int(11) NOT NULL DEFAULT '0',
  `i_tribe_id` int(11) NOT NULL DEFAULT '0',
  `i_genus_id` int(11) NOT NULL DEFAULT '0',
  `i_species_id` int(11) NOT NULL DEFAULT '0',
  `h_family_id` int(11) NOT NULL DEFAULT '0',
  `h_genus_id` int(11) NOT NULL DEFAULT '0',
  `h_species_id` int(11) NOT NULL DEFAULT '0',
  `coll_number_same_h` int(11) NOT NULL DEFAULT '0',
  `coll_percent` decimal(4,2) NOT NULL DEFAULT '0.00',
  `h_n_specimens` int(11) NOT NULL DEFAULT '0',
  `i_h_same_g` varchar(40) DEFAULT 'FALSE',
  `i_h_same_f` varchar(40) DEFAULT 'FALSE',
  `i_j_h_col_event` int(11) NOT NULL DEFAULT '0',
  `i_j_same_col` int(11) NOT NULL DEFAULT '0',
  `h_voucher` varchar(40) DEFAULT 'FALSE',
  `coll_total_i` int(11) NOT NULL DEFAULT '0',
  `rel_confidence` varchar(40) NOT NULL DEFAULT 'LOW',
  `redList` varchar(40) DEFAULT NULL,


  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;