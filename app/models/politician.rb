class Politician < ActiveRecord::Base
  has_many :careers

  # -- acts_as_votable ------------
  acts_as_votable

  def full_name
    return "#{self.first_name + ' ' if !self.first_name.nil?}#{self.last_name}"
  end

  # adds sql select that allows us to sort by heirarcy (pres, vice pres, senator, etc)
  def self.select_title_heirarchy
    select("case when upper(careers.title) = 'PRESIDENT' then 1
          when upper(careers.title) = 'VICE-PRESIDENT' then 2
          when upper(careers.title) = 'SENATOR' then 3
          when upper(careers.title) in ('CONGRESSMAN', 'ASSEMBLYMAN', 'PARTY-LIST') then 4
          when upper(careers.title) in ('GOVERNOR', 'PROVINCIAL GOVERNOR') then 5
          when upper(careers.title) in ('VICE-GOVERNOR', 'PROVINCIAL VICE-GOVERNOR') then 6
          when upper(careers.title) in ('MAYOR', 'CITY MAYOR') then 7
          when upper(careers.title) in ('VICE-MAYOR', 'CITY VICE-MAYOR') then 8
          else 9
          end as title_heirarchy")
  end

end
