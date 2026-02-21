using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class ShieldSlam : Ability
    {
        public ShieldSlam()
        {
            Name = "Shield Slam";
            FlavorText = "A devastating blow with a reinforced shield.";
            ModifiedStat = StatEnum.PhysicalAttack;
            Modifier = 4;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 2;
        }
    }
}
