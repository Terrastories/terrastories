require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to define_enum_for(:role).with_values(%i[user editor]) }

  describe 'Callbacks' do
    describe 'after_initialize' do
      subject(:user) { User.new(params) }

      context 'with role' do
        let(:params) { Hash[:role, :editor] }

        it 'uses role from params' do
          expect(user.role).to eq('editor')
        end
      end

      context 'without role' do
        let(:params) { Hash.new }

        it 'sets default user role' do
          expect(user.role).to eq('user')
        end
      end
    end
  end
end
