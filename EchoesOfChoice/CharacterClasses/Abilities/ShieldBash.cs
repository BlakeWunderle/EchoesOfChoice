using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class ShieldBash : Ability
    {
        public ShieldBash()
        {
            Name = "Shield Bash";
            FlavorText = "Slam the shield into the enemy's face.";
            ModifiedStat = StatEnum.PhysicalAttack;
            Modifier = 5;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 2;
        }
    }
}
