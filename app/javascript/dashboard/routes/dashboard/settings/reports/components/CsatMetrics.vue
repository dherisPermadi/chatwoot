<template>
  <div class="flex flex-wrap mx-0 csat--metrics-container">
    <csat-metric-card
      :label="$t('CSAT_REPORTS.METRIC.TOTAL_RESPONSES.LABEL')"
      :info-text="$t('CSAT_REPORTS.METRIC.TOTAL_RESPONSES.TOOLTIP')"
      :value="responseCount"
    />
    <csat-metric-card
      :disabled="ratingFilterEnabled"
      :label="$t('CSAT_REPORTS.METRIC.SATISFACTION_SCORE.LABEL')"
      :info-text="$t('CSAT_REPORTS.METRIC.SATISFACTION_SCORE.TOOLTIP')"
      :value="ratingFilterEnabled ? '--' : formatToPercent(satisfactionScore)"
    />
    <csat-metric-card
      :label="$t('CSAT_REPORTS.METRIC.RESPONSE_RATE.LABEL')"
      :info-text="$t('CSAT_REPORTS.METRIC.RESPONSE_RATE.TOOLTIP')"
      :value="formatToPercent(responseRate)"
    />
    <div
      v-if="metrics.totalResponseCount && !ratingFilterEnabled"
      class="w-[50%] max-w-[50%] flex-[50%] report-card"
    >
      <h3 class="heading text-slate-800 dark:text-slate-100">
        <div class="emoji--distribution">
          <div
            v-for="(rating, key, index) in ratingPercentage"
            :key="rating + key + index"
            class="emoji--distribution-item"
          >
            <span class="emoji--distribution-key">{{
              ratingToEmoji(key)
            }}</span>
            <span>{{ formatToPercent(rating) }}</span>
          </div>
        </div>
      </h3>
      <div class="emoji--distribution-chart">
        <woot-horizontal-bar :collection="chartData" :height="24" />
      </div>
    </div>
  </div>
</template>
<script>
import { mapGetters } from 'vuex';
import CsatMetricCard from './CsatMetricCard';
import { CSAT_RATINGS } from 'shared/constants/messages';

export default {
  components: {
    CsatMetricCard,
  },
  props: {
    filters: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      csatRatings: CSAT_RATINGS,
    };
  },
  computed: {
    ...mapGetters({
      metrics: 'csat/getMetrics',
      ratingPercentage: 'csat/getRatingPercentage',
      satisfactionScore: 'csat/getSatisfactionScore',
      responseRate: 'csat/getResponseRate',
    }),
    ratingFilterEnabled() {
      return Boolean(this.filters.rating);
    },
    chartData() {
      return {
        labels: ['Rating'],
        datasets: CSAT_RATINGS.map(rating => ({
          label: rating.emoji,
          data: [this.ratingPercentage[rating.value]],
          backgroundColor: rating.color,
        })),
      };
    },
    responseCount() {
      return this.metrics.totalResponseCount
        ? this.metrics.totalResponseCount.toLocaleString()
        : '--';
    },
  },
  methods: {
    formatToPercent(value) {
      return value ? `${value}%` : '--';
    },
    ratingToEmoji(value) {
      return CSAT_RATINGS.find(rating => rating.value === Number(value)).emoji;
    },
  },
};
</script>
<style lang="scss" scoped>
.csat--metrics-container {
  @apply bg-white dark:bg-slate-800 rounded p-4 mb-5 border border-solid border-slate-75 dark:border-slate-700;
}

.emoji--distribution {
  @apply flex justify-end;

  .emoji--distribution-item {
    @apply pl-4;
  }
}

.emoji--distribution-chart {
  @apply mt-2;
}

.emoji--distribution-key {
  @apply my-0 mx-0.5;
}
</style>
