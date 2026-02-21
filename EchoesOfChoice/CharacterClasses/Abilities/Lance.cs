using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Lance : Ability
    {
        public Lance()
        {
            Name = "Lance";
            FlavorText = "A devastating mounted charge with lance leveled.";
            ModifiedStat = StatEnum.PhysicalAttack;
            Modifier = 6;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
