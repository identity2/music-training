## Project Description
This is an iOS tuner & music theory training app written in Swift with AudioKit.

There are four main functions:
1. Tuner & Metronome.
2. Sight Reading.
3. Sight Singing.
4. Interval Dictation.
5. Chord Progression Dictation.

[Project Page](http://shinerightstudio.com/tuner-music-training)


## Documentation
### Note Convert Table
The note convert table for `getNoteBy(index:isTreble:)`:

    |       | Bass  |        | Treble  |        |
    |-------|-------|--------|---------|--------|
    | Index | Note  | Octave | Note    | Octave |
    | 0     | D     | 2      | B       | 3      |
    | 1     | E     |        | C       | 4      |
    | 2     | F     |        | D       |        |
    | 3     | G     |        | E       |        |
    | 4     | A     |        | F       |        |
    | 5     | B     |        | G       |        |
    | 6     | C     | 3      | A       |        |
    | 7     | D     |        | B       |        |
    | 8     | E     |        | C       | 5      |
    | 9     | F     |        | D       |        |
    | 10    | G     |        | E       |        |
    | 11    | A     |        | F       |        |
    | 12    | B     |        | G       |        |
    | 13    | C     | 4      | A       |        |
    | 14    | D     |        | B       |        |
    
### Interval Names
    | Semitone Diff. | Name  |
    |----------------|-------|
    | 0              | P1    |
    | 1              | m2    |
    | 2              | M2    |
    | 3              | m3    |
    | 4              | M3    |
    | 5              | P4    |
    | 6              | A4/d5 |
    | 7              | P5    |
    | 8              | m6    |
    | 9              | M6    |
    | 10             | m7    |
    | 11             | M7    |
    | 12             | P8    |
    
    P1 will not appear in the interval training.
