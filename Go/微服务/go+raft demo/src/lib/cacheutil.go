package lib

import (
	"time"

	"github.com/dgraph-io/badger/v2"
)

type Bcache struct {
	*badger.DB
}

func NewBcache(path string) *Bcache {
	options := badger.DefaultOptions(path)
	options.Truncate = true //for windows
	db, err := badger.Open(options)
	if err != nil {
		panic(err)
	}
	return &Bcache{DB: db}
}

//带过期时间的setter
func (this *Bcache) SetItemWithTTl(key string, value string, ttl time.Duration) error {
	err := this.Update(func(txn *badger.Txn) error {
		e := badger.NewEntry([]byte(key), []byte(value)).WithTTL(ttl)
		return txn.SetEntry(e)
	})
	return err
}
func (this *Bcache) KeysWithPrefix(size int, prefix string) ([]string, error) {
	keys := make([]string, 0)
	err := this.View(func(txn *badger.Txn) error {
		itopt := badger.IteratorOptions{
			PrefetchValues: false,
			PrefetchSize:   size,
			Reverse:        false,
			AllVersions:    false,
		}
		itor := txn.NewIterator(itopt)
		defer itor.Close()
		prefix_bytes := []byte(prefix)
		for itor.Seek(prefix_bytes); itor.ValidForPrefix(prefix_bytes); itor.Next() {
			key := string(itor.Item().Key())
			keys = append(keys, key)
		}
		return nil
	})
	return keys, err
}
func (this *Bcache) Keys(size int) ([]string, error) {
	keys := make([]string, 0)
	err := this.View(func(txn *badger.Txn) error {
		itopt := badger.IteratorOptions{
			PrefetchValues: false,
			PrefetchSize:   size,
			Reverse:        false,
			AllVersions:    false,
		}
		itor := txn.NewIterator(itopt)
		defer itor.Close()
		for itor.Rewind(); itor.Valid(); itor.Next() {
			key := string(itor.Item().Key())
			keys = append(keys, key)
		}
		return nil
	})
	return keys, err
}

func (this *Bcache) SetItem(key string, value string) error {
	err := this.Update(func(txn *badger.Txn) error {
		return txn.Set([]byte(key), []byte(value))
	})
	return err
}
func (this *Bcache) SetItemWithBytes(key []byte, value []byte) error {
	err := this.Update(func(txn *badger.Txn) error {
		return txn.Set(key, value)
	})
	return err
}

func (this *Bcache) GetItem(key []byte) ([]byte, error) {
	var ret []byte
	err := this.View(func(txn *badger.Txn) error {
		item, err := txn.Get(key)
		if err != nil {
			return err
		}
		_ = item.Value(func(val []byte) error {
			ret = val
			return nil
		})
		return nil
	})
	if err != nil {
		return nil, err
	}
	return ret, nil
}
