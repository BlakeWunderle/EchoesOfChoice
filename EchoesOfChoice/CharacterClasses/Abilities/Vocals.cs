using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    class Vocals : Ability
    {
        public Vocals()
        {
            Name = "Vocals";
            FlavorText = "Sing a song that bursts the enemies' eardrums.";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 6;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 5;
        }
    }
}
