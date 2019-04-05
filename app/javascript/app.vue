<template lang='pug'>
  #app
    main(role="main")
      h1(v-if="loading") Loading...
      div(v-else)
        h2
          | month
          input(v-model="month")
          button.btn.btn-primary(v-if="month", @click="reloadTransactions") Change month
        ul.nav.nav-tabs
          li(:class="transactionType == 'expense' ? 'active' : ''")
            a(href="#" @click.prevent="transactionType = 'expense'") Expenses
          li(:class="transactionType == 'income' ? 'active' : ''")
            a(href="#" @click.prevent="transactionType = 'income'") Incomes
        
        ul.nav.nav-pills
          li(:class="!category ? 'active' : ''")
            a(href='#' @click.prevent="category = null") All
          li(v-for="cat in categories" :class="category == cat.name ? 'active' : ''")
            a(href='#' @click.prevent="category = cat.name") {{cat.name}} <span class="badge">{{cat.amount}}</span>
        
        table.table
          thead: tr
            th date
            th amount
            th description
            th category
            th
            th
          tbody
            tr(v-for="t in transactions")
              td {{t.date}}
              td {{t.amount}}
              td
                .description-container
                  | {{t.description}}
                  a(href='#' @click.prevent="toggleShowRaw(t)") show raw
                div(v-if="t.showRaw")
                  small {{t.original_date}} - {{t.raw_description}}
              td
                a(href='#' v-if="t.category" @click.prevent="toggleCategoryEditMode(t)")
                  span.label.label-default {{t.category}}
              td
                div(v-if="!t.category || t.showCategoryEditUi")
                  .form-group
                    select.form-control.select-category(value="t.selected" @change="handleCategoryChangeEvent($event, t)")
                      option(value="") Please select one
                      option(v-for="cat in allCategories" v-bind:value="cat") {{ cat }}
              td
                a.btn.btn-primary(href="#" v-if="t.category && !t.triggered_apply_to_similar" @click.prevent="applyToSimilar(t)") Apply to similar
</template>

<script>
export default {
  data () {
    return {
      transactionType: 'expense',
      category: null,
      categories: [],
      transactions: [],
      allCategories: [],
      month: new Date().toISOString(),
      loading: false
    }
  },
  created() {
    this.reloadTransactions();
  },
  watch: {
    category(newVal) {
      this.reloadTransactions();
    },
    transactionType(newVal) {
      if(newVal){
        this.reloadTransactions();
      }
    }
  },
  methods: {
    reloadTransactions() {
      this.loading = true;
      let vm = this;
      
      let params = {
        category: this.category,
        month: this.month,
        transaction_type: this.transactionType,
      }
      $.getJSON("/transactions.json", params, function(response) {
        vm.allCategories = response.all_categories;
        vm.categories = response.categories;
        vm.transactions = response.transactions;
        vm.transactions = vm.transactions.map(t => {
          if (!t.category) {
            if (t.description.toLowerCase().search('uber') > -1 && t.description.toLowerCase().search('trip') > -1) {
              t.category = 'taxi';
              vm.updateTransaction(t.id, {category: t.category});
            }

            if (t.description.toLowerCase().search('cash at') > -1) {
              t.category = 'cash';
              vm.updateTransaction(t.id, {category: t.category});
            }
          }

          return t;
        });
        vm.loading = false;
      });
    },
    toggleShowRaw(transaction) {
      this.transactions = this.transactions.map((t) => {
        if (t.id == transaction.id) {
          t.showRaw = !!!t.showRaw
        }
        return t;
      });
    },
    toggleCategoryEditMode(transaction) {
      this.transactions = this.transactions.map((t) => {
        if (t.id == transaction.id) {
          t.showCategoryEditUi = !!!t.showCategoryEditUi
        }
        return t;
      });
    },
    handleCategoryChangeEvent(event, transaction) {
      transaction.category = event.target.value;
      this.updateTransaction(transaction.id, {category: transaction.category})
    },
    applyToSimilar(transaction) {
      this.applyToSimilarUpdate(transaction.id);
    },
    updateTransaction(id, attributes) {
      $.ajax({
        url: `/transactions/${id}.json`,
        type: 'PUT',
        data: {authenticity_token: $('[name="csrf-token"]')[0].content, transaction: attributes},
        error(error) {
          alert(error);
        }
      })
    },
    applyToSimilarUpdate(id) {
      let vm = this;
      $.ajax({
        url: `/transactions/${id}/apply_category_to_similar.json`,
        type: 'GET',
        success(response) {
          vm.reloadTransactions();
        },
        error(error) {
          alert(error);
        }
      })
    }
  }
}
</script>