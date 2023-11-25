{
  _config+:: {
    env+: {
      values+: [
        {
          key: 'rampup',
          value: '1',
        },
        {
          key: 'loop_count',
          value: '1',
        },
        {
          key: 'thread_count',
          value: '1',
        },
      ],
    },
  },
}