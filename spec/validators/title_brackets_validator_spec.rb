require "rails_helper"

class TitleBracketsValidator  < ActiveModel::Validator

  def validate(record)

  	title = record.title
  	chars_title = title.split('')
  	brackets = ['[', ']', '(', ')', '{', '}']
  	open_brackets = ['[', '(', '{']
  	chars_title.delete_if {|x| brackets.exclude? x}

  	if /\(\s*\)/.match(title) or /\{\s*\}/.match(title) or /\[\s*\]/.match(title)
  		record.errors.add(:base, "Empty brackets/parentheses")
  	end

		i = 0
	  chars_title.length.times {
	  	open_id = open_brackets.index(chars_title[i])

	  	if open_id == nil 
          if i == 0 and chars_title.present?
            record.errors.add(:base, "Closing symbol on left side")
          end
	  	elsif chars_title[i + 1] == brackets[open_id*2 + 1]
	  		 chars_title.delete_at(i)
	  		 chars_title.delete_at(i)
	  		 i = 0
   		else
   			i += 1
		  end
	  }

    if chars_title.length > 0 
    		record.errors.add(:base, "Missing closing symbol")
    end
	end
end

 describe TitleBracketsValidator do
   subject { Validatable.new(title: title) }

   shared_examples "has valid title" do
     it "should be valid" do
       expect(subject).to be_valid
     end
   end

   shared_examples "has invalid title" do
     it "should not be valid" do
       expect(subject).not_to be_valid
     end
   end

   context "with curly brackets" do
     let(:title) { "The Fellowship of the Ring {Peter Jackson}" }
     it_behaves_like "has valid title"
   end

   context "with square brackets" do
     let(:title) { "The Fellowship of the Ring [Lord of The Rings]" }
     it_behaves_like "has valid title"
   end

   context "with not closed brackets" do
     let(:title) { "The Fellowship of the Ring (2001" }
     it_behaves_like "has invalid title"
   end

   context "with not opened brackets" do
     let(:title) { "The Fellowship of the Ring 2001)" }
     it_behaves_like "has invalid title"
   end

   context "with not too much closing brackets" do
     let(:title) { "The Fellowship of the Ring (2001) - 2003)" }
     it_behaves_like "has invalid title"
   end

   context "with not too much opening brackets" do
     let(:title) { "The Fellowship of the Ring (2001 - (2003)" }
     it_behaves_like "has invalid title"
   end

   context "with empty brackets" do
     let(:title) { "The Fellowship of the Ring ()" }
     it_behaves_like "has invalid title"
   end

   context "with brackets in wrong order" do
     let(:title) { "The Fellowship of the )Ring(" }
     it_behaves_like "has invalid title"
   end

   context "with matching brackets" do
     let(:title) { "The Fellowship of the Ring (2001)" }
     it_behaves_like "has valid title"
   end

   context "with multiple matching brackets" do
     let(:title) { "The Fellowship of the Ring [Lord of The Rings] (2001) {Peter Jackson}" }
     it_behaves_like "has valid title"
   end

   context "with nested matching brackets" do
     let(:title) { "The Fellowship of the Ring [Lord of The Rings {Peter Jackson}] (2012)" }
     it_behaves_like "has valid title"
   end

   context "with no brackets" do
     let(:title) { "Lord of The Rings" }
     it_behaves_like "has valid title"
   end
 end

class Validatable
  include ActiveModel::Validations
  validates_with TitleBracketsValidator
  attr_accessor :title

  def initialize(title:)
    @title = title
  end
end
