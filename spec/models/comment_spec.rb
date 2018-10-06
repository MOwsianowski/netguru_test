require "rails_helper"

describe Comment do
  it { is_expected.to allow_value("text comment").for(:text) }
  it { is_expected.not_to allow_value("").for(:text) }
end