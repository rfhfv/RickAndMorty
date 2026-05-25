import UIKit

protocol RMCharacterListViewViewModelDelegate: AnyObject {
    func didLoadInitalCharacters()
}

final class RMCharacterListViewViewModel: NSObject {
    public weak var delegate: RMCharacterListViewViewModelDelegate?
    
    private var characters: [RMCharacter] = [] {
        didSet {
            createCellViewModels()
        }
    }
    
    private var cellViewModels: [RMCharacterCollectionViewCellViewModel] = []
    
    private func createCellViewModels() {
        cellViewModels = characters.map { character in
            RMCharacterCollectionViewCellViewModel(
                characterName: character.name,
                characterStatus: character.status,
                characterImageUrl: URL(string: character.image))
        }
    }
    
    public func fetchCharacters() {
        RMService.shared.execute(
            .listCharactersRequests,
            expecting: RMGetAllCharactesResponse.self) { [weak self] result in
                guard let self else { return }
                
                switch result {
                case .success(let responseModel):
                    let results = responseModel.results
                    self.characters = results
                    DispatchQueue.main.async {
                        self.delegate?.didLoadInitalCharacters()
                    }
                case .failure(let error):
                    print(String(describing: error))
                }
            }
    }
}

extension RMCharacterListViewViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RMCharacterCollectionViewCell.identifier, for: indexPath) as? RMCharacterCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configure(with: cellViewModels[indexPath.item])
        return cell
    }
}

extension RMCharacterListViewViewModel: UICollectionViewDelegate { }

extension RMCharacterListViewViewModel: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounts = UIScreen.main.bounds
        let width = (bounts.width-30)/2
        return CGSize(
            width: width,
            height: width * 1.5
        )
    }
}
