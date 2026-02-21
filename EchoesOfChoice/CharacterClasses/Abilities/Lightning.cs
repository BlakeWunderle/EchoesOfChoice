using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Lightning : Ability
    {
        public Lightning()
        {
            Name = "Lightning";
            FlavorText = "Call down lightning to turn your opponent to a pile of ash.";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 5;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
