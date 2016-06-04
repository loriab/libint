/*
 *  This file is a part of Libint.
 *  Copyright (C) 2004-2014 Edward F. Valeev
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see http://www.gnu.org/licenses/.
 *
 */

#ifndef _libint2_src_bin_libint_intpartiter_h_
#define _libint2_src_bin_libint_intpartiter_h_

#include <cstdint>
#include <numeric>
#include <limits>
#include <array>
#include <cassert>
#include <stdexcept>
#include <type_traits>
#include <iterator>

namespace libint2 {

  namespace detail {
	template <class C>
	constexpr auto size(const C& c) -> decltype(c.size())
	{
		return c.size();
	}

	template <class T, std::size_t N>
	constexpr std::size_t size(const T (&array)[N]) noexcept
	{
	    return N;
	}

	template <typename T>
	struct has_static_size;
	template <typename T, size_t N>
	struct has_static_size<std::array<T,N>> : std::true_type {};
	template <typename T, size_t N>
	struct has_static_size<T[N]> : std::true_type {};
	template <typename T>
	struct has_static_size : std::false_type {};


  } // namespace libint2::detail


  /// Iterates over all partitions of a non-negative integer \f$n\f$ into \f$k>0\f$ nonnegative integers
  /// in reverse lexicographical order. E.g. partitions of \f$n=2\f$ into sets of \f$k=3\f$ integers
  /// appear in this order: {2 0 0}, {1 1 0}, {1 0 1}, {0 2 0}, {0 1 1}, and {0 0 2}.
  /// @tparam Sequence integer sequence with dense storage (std::vector, std::array, and built-in array will work)
  template <typename Sequence,
  	  	  	typename = typename std::enable_if<std::numeric_limits<typename Sequence::value_type>::is_integer>::type>
  struct FixedOrderedIntegerPartitionIterator {
    public:
	  typedef const Sequence& value_type;
	  typedef typename Sequence::value_type integer_type;
	  typedef typename std::make_unsigned<integer_type>::type unsigned_integer_type;
	  typedef typename Sequence::size_type size_type;

	  /// \param n the positive integer to be partitioned
	  /// \param k  the number of partitions, 1 or greater
	  template <typename = typename std::enable_if<detail::has_static_size<Sequence>::value>::type>
	  FixedOrderedIntegerPartitionIterator(unsigned_integer_type n) : n_(n) {
        assert(n >= 0);
        // initialize partition_
        std::fill(std::begin(partition_), std::end(partition_), integer_type(0));
        partition_[0] = n_;
      }

	  /// \param n the positive integer to be partitioned
	  /// \param k  the number of partitions, 1 or greater
	  FixedOrderedIntegerPartitionIterator(unsigned_integer_type n,
			  size_type k) : n_(n) {
        assert(n >= 0);
        assert(k > 0);
        // initialize partition_
		resize(partition_, k);
        std::fill(std::begin(partition_), std::end(partition_), integer_type(0));
        partition_[0] = n_;
      }

	  /// @return the number of unique partitions
	  intmax_t range_size() const {
		intmax_t result = 1;
        const auto partition_size = detail::size(partition_);
        for(intmax_t d=1; d<=n_; ++d) {
          result *= (partition_size+d-1); result /= d;
        }
        return result;
      }

      value_type operator*() const {
        return partition_;
      }

      Sequence* operator->() const {
        return &partition_;
      }

      /// @return true if \c operator* returns the last partition in the range
      operator bool() const {
    	  return this->last();
      }

      /// @return true if \c operator* returns the last partition in the range
      bool last() const {
        return last(&partition_[0], detail::size(partition_));
      }

      /// update to the next partition in the range
      /// @throw if last() == true
      void next() {
        next(&partition_[0], detail::size(partition_));
      }

      /// returns the rank (index) of partition \c part in the partition range
      static size_t rank(const value_type part) {
    	  assert(false); // not yet implemented
      }

    private:
      unsigned long n_;
      Sequence partition_;

      static void
      first(integer_type* partition, size_type size) {
        assert(size > 0);
        const auto n = std::accumulate(partition, partition+size, unsigned_integer_type(0));
        std::fill(partition, partition+size, integer_type(0));
        partition[0] = n;
      }
      static bool
      last(const integer_type* partition, size_type size) {
    	assert(size > 0);
        const auto n = std::accumulate(partition, partition+size, 0u);
        return partition[size-1] == n;
      }
      static void
      next(integer_type* partition, size_type size) {
        assert(size > 0);
        if (size == 1) return;
        if (last(partition+1, size-1)) {
          assert(partition[0]!=0u);
          --partition[0];
          ++partition[1];
          first(partition+1, size-1);
        }
        else
          next(partition+1, size-1);
      }
  };

  /// Iterates over unique derivative indices
  template <unsigned int NCenters> using CartesianDerivIterator =
		  FixedOrderedIntegerPartitionIterator<std::array<unsigned int, NCenters*3>>;

}

#endif /* header guard */