using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class RunicStrike : Ability
    {
        public RunicStrike()
        {
            Name = "Runic Strike";
            FlavorText = "Channel arcane energy through your weapon, striking with both physical and magical force.";
            ModifiedStat = StatEnum.MixedAttack;
            Modifier = 7;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 4;
        }
    }
}
